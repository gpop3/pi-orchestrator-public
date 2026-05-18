resource "null_resource" "directories" {
  triggers = {
    config_path = "${var.data_dir}/mqtt/config"
    data_path   = "${var.data_dir}/mqtt/data"
    log_path    = "${var.data_dir}/mqtt/log"
  }

  provisioner "local-exec" {
    command = <<EOT
sudo mkdir -p ${var.data_dir}/mqtt/config
sudo mkdir -p ${var.data_dir}/mqtt/data
sudo mkdir -p ${var.data_dir}/mqtt/log
sudo chown -R ${var.puid}:${var.pgid} ${var.data_dir}/mqtt
EOT
  }
}

resource "null_resource" "config" {
  triggers = {
    config_file = "${var.data_dir}/mqtt/config/mosquitto.conf"
  }

  provisioner "local-exec" {
    command = <<EOT
sudo tee ${var.data_dir}/mqtt/config/mosquitto.conf >/dev/null <<'EOF'
listener 1883
allow_anonymous true

listener 9001
protocol websockets
allow_anonymous true

persistence true
persistence_location /mosquitto/data/

log_dest file /mosquitto/log/mosquitto.log
log_dest stdout
EOF
sudo chown ${var.puid}:${var.pgid} ${var.data_dir}/mqtt/config/mosquitto.conf
sudo chmod 0644 ${var.data_dir}/mqtt/config/mosquitto.conf
EOT
  }

  depends_on = [
    null_resource.directories
  ]
}

resource "docker_image" "this" {
  name         = var.image
  keep_locally = true
}

resource "docker_container" "this" {
  name  = "mosquitto"
  image = docker_image.this.repo_digest

  restart = "unless-stopped"

  ports {
    internal = 1883
    external = var.mqtt_port
    protocol = "tcp"
  }

  ports {
    internal = 9001
    external = var.websocket_port
    protocol = "tcp"
  }

  volumes {
    host_path      = "${var.data_dir}/mqtt/config"
    container_path = "/mosquitto/config"
  }

  volumes {
    host_path      = "${var.data_dir}/mqtt/data"
    container_path = "/mosquitto/data"
  }

  volumes {
    host_path      = "${var.data_dir}/mqtt/log"
    container_path = "/mosquitto/log"
  }

  depends_on = [
    null_resource.config
  ]
}