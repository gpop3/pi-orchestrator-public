resource "null_resource" "directories" {
  triggers = {
    data_path = "${var.data_dir}/node-red/data"
  }

  provisioner "local-exec" {
    command = <<EOT
sudo mkdir -p ${var.data_dir}/node-red/data
sudo chown -R ${var.puid}:${var.pgid} ${var.data_dir}/node-red/data
EOT
  }
}

resource "docker_image" "this" {
  name         = var.image
  keep_locally = true
}

resource "docker_container" "this" {
  name  = "nodered"
  image = docker_image.this.repo_digest

  restart = "unless-stopped"

  ports {
    internal = 1880
    external = var.port
    protocol = "tcp"
  }

  env = [
    "TZ=${var.timezone}"
  ]

  volumes {
    host_path      = "${var.data_dir}/node-red/data"
    container_path = "/data"
  }

  depends_on = [
    null_resource.directories
  ]
}