resource "null_resource" "directories" {
  triggers = {
    config_path = "${var.data_dir}/homeassistant/config"
  }

  provisioner "local-exec" {
    command = <<EOT
sudo mkdir -p ${var.data_dir}/homeassistant/config
EOT
  }
}

resource "docker_image" "this" {
  name         = var.image
  keep_locally = true
}

resource "docker_container" "this" {
  name  = "homeassistant"
  image = docker_image.this.repo_digest

  restart      = "unless-stopped"
  network_mode = "host"

  env = [
    "TZ=${var.timezone}"
  ]

  capabilities {
    add = ["NET_ADMIN"]
  }

  volumes {
    host_path      = "${var.data_dir}/homeassistant/config"
    container_path = "/config"
  }

  volumes {
    host_path      = "/run/dbus"
    container_path = "/run/dbus"
    read_only      = true
  }

  devices {
    host_path      = var.zigbee_device
    container_path = "/dev/ttyUSB0"
  }

  depends_on = [
    null_resource.directories
  ]

  lifecycle {
    ignore_changes = [
      capabilities,
    ]
  }
}