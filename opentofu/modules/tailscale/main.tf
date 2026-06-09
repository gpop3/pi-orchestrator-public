resource "null_resource" "serve_config" {
  triggers = {
    serve_file   = "${var.data_dir}/tailscale/serve.json"
    nginx_target = var.nginx_target
  }

  provisioner "local-exec" {
    command = <<EOT
sudo mkdir -p ${var.data_dir}/tailscale
sudo tee ${var.data_dir}/tailscale/serve.json >/dev/null <<'EOF'
{
  "TCP": {
    "443": { "HTTPS": true },
    "2222": { "TCPForward": "bastion:22" }
  },
  "Web": {
    "$${TS_CERT_DOMAIN}:443": {
      "Handlers": { "/": { "Proxy": "http://${var.nginx_target}" } }
    }
  }
}
EOF
sudo chmod 0644 ${var.data_dir}/tailscale/serve.json
EOT
  }
}

resource "docker_image" "this" {
  name         = var.image
  keep_locally = true
}

resource "docker_container" "this" {
  name     = "ts-gateway"
  image    = docker_image.this.repo_digest
  hostname = var.hostname

  restart = "unless-stopped"

  networks_advanced {
    name         = var.edge_network
    ipv4_address = var.edge_ip
  }

  env = [
    "TS_AUTHKEY=${var.authkey}",
    "TS_STATE_DIR=/var/lib/tailscale",
    "TS_USERSPACE=true",
    "TS_SERVE_CONFIG=/config/serve.json",
    "TS_EXTRA_ARGS=--advertise-tags=tag:gateway --reset",
  ]

  capabilities {
    add = ["NET_ADMIN"]
  }

  volumes {
    host_path      = "${var.data_dir}/tailscale/state"
    container_path = "/var/lib/tailscale"
  }

  volumes {
    host_path      = "${var.data_dir}/tailscale/serve.json"
    container_path = "/config/serve.json"
    read_only      = true
  }

  depends_on = [
    null_resource.serve_config
  ]

  lifecycle {
    ignore_changes = [
      capabilities,
    ]
  }
}
