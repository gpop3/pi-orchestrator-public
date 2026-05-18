resource "null_resource" "directories" {
  triggers = {
    data_path = "${var.data_dir}/mealie-data"
  }

  provisioner "local-exec" {
    command = <<EOT
sudo mkdir -p ${var.data_dir}/mealie-data
sudo chown -R ${var.puid}:${var.pgid} ${var.data_dir}/mealie-data
EOT
  }
}

resource "docker_image" "this" {
  name         = var.image
  keep_locally = true
}

resource "docker_container" "this" {
  name  = "mealie"
  image = docker_image.this.repo_digest

  restart = "unless-stopped"

  ports {
    internal = 9000
    external = var.port
    protocol = "tcp"
  }

  env = [
    "PUID=${var.puid}",
    "PGID=${var.pgid}",
    "TZ=${var.timezone}",
    "BASE_URL=${var.base_url}",
    "ALLOW_SIGNUP=${var.allow_signup}"
  ]

  volumes {
    host_path      = "${var.data_dir}/mealie-data"
    container_path = "/app/data"
  }

  depends_on = [
    null_resource.directories
  ]
}