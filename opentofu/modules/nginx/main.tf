resource "null_resource" "config" {
  triggers = {
    config_file = "${var.data_dir}/nginx/nginx.conf"
    ha_upstream = var.ha_upstream
  }

  provisioner "local-exec" {
    command = <<EOT
sudo mkdir -p ${var.data_dir}/nginx
sudo tee ${var.data_dir}/nginx/nginx.conf >/dev/null <<'EOF'
server {
    listen 80;
    server_name _;

    resolver 127.0.0.11 valid=10s;

    location / {
        set $ha_upstream "${var.ha_upstream}";
        proxy_pass http://$ha_upstream;

        proxy_http_version 1.1;
        proxy_set_header Upgrade           $http_upgrade;
        proxy_set_header Connection        "upgrade";
        proxy_set_header Host              $host;
        proxy_set_header X-Real-IP         $remote_addr;
        proxy_set_header X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_read_timeout  90s;
        proxy_send_timeout  90s;
    }
}
EOF
sudo chmod 0644 ${var.data_dir}/nginx/nginx.conf
EOT
  }
}

resource "docker_image" "this" {
  name         = var.image
  keep_locally = true
}

resource "docker_container" "this" {
  name  = "rev-proxy"
  image = docker_image.this.repo_digest

  restart = "unless-stopped"

  networks_advanced {
    name = var.edge_network
  }
  networks_advanced {
    name = var.backend_network
  }

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  ports {
    internal = 80
    external = var.port
    protocol = "tcp"
  }

  volumes {
    host_path      = "${var.data_dir}/nginx/nginx.conf"
    container_path = "/etc/nginx/conf.d/default.conf"
    read_only      = true
  }

  depends_on = [
    null_resource.config
  ]
}
