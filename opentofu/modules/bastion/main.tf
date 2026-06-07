resource "null_resource" "prepare" {
  triggers = {
    dir = "${var.data_dir}/bastion"
  }

  provisioner "local-exec" {
    command = <<EOT
sudo mkdir -p ${var.data_dir}/bastion/log
sudo touch ${var.data_dir}/bastion/authorized_keys
sudo touch ${var.data_dir}/bastion/google_authenticator
sudo chmod 0644 ${var.data_dir}/bastion/authorized_keys
sudo chmod 0600 ${var.data_dir}/bastion/google_authenticator
EOT
  }
}

resource "docker_image" "this" {
  name = "pi-bastion:latest"

  build {
    context    = "${path.module}/docker"
    dockerfile = "Dockerfile"
  }

  triggers = {
    docker_dir = sha1(join("", [for f in fileset("${path.module}/docker", "**") : filesha1("${path.module}/docker/${f}")]))
  }
}

resource "docker_container" "this" {
  name     = "bastion"
  image    = docker_image.this.image_id
  hostname = "bastion"

  restart = "unless-stopped"

  networks_advanced {
    name = var.edge_network
  }

  host {
    host = "host.docker.internal"
    ip   = "host-gateway"
  }

  env = [
    "WEBHOOK_URL=${var.webhook_url}",
    "WEBHOOK_TOKEN=${var.webhook_token}",
  ]

  ports {
    internal = 22
    external = var.ssh_port
    protocol = "tcp"
  }

  volumes {
    host_path      = "${var.data_dir}/bastion/authorized_keys"
    container_path = "/home/jump/.ssh/authorized_keys"
    read_only      = true
  }

  volumes {
    host_path      = "${var.data_dir}/bastion/google_authenticator"
    container_path = "/home/jump/.google_authenticator"
  }

  volumes {
    host_path      = "${var.data_dir}/bastion/log"
    container_path = "/var/log/bastion"
  }

  depends_on = [
    null_resource.prepare
  ]
}
