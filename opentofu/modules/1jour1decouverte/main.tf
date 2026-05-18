resource "null_resource" "directories" {
  triggers = {
    data_path = "${var.data_dir}/1jour1decouverte/data"
  }

  provisioner "local-exec" {
    command = <<EOT
sudo mkdir -p ${var.data_dir}/1jour1decouverte/data
sudo chown -R ${var.puid}:${var.pgid} ${var.data_dir}/1jour1decouverte
EOT
  }
}

data "docker_registry_image" "registry_image_app" {
  name = var.image
}

resource "docker_image" "this" {
  name          = data.docker_registry_image.registry_image_app.name
  pull_triggers = [data.docker_registry_image.registry_image_app.sha256_digest]
  keep_locally  = true
}

resource "docker_container" "this" {
  name  = var.container_name
  image = docker_image.this.repo_digest

  restart = "unless-stopped"

  env = [
    "ANTHROPIC_API_KEY=${var.anthropic_api_key}",
    "TWILIO_ACCOUNT_SID=${var.twilio_account_sid}",
    "TWILIO_AUTH_TOKEN=${var.twilio_auth_token}",
    "TWILIO_FROM=${var.twilio_from}",
    "WHATSAPP_TO=${var.whatsapp_to}",
    "HEURE_ENVOI=${var.heure_envoi}",
    "PYTHONUNBUFFERED=1",
    "TZ=${var.timezone}"
  ]

  volumes {
    host_path      = "${var.data_dir}/1jour1decouverte/data"
    container_path = "/data"
  }

  log_driver = "json-file"

  log_opts = {
    max-size = var.log_max_size
    max-file = var.log_max_file
  }

  depends_on = [
    null_resource.directories
  ]
}