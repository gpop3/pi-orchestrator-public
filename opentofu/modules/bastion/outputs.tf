output "container_name" {
  value = docker_container.this.name
}

output "ssh_port" {
  value = var.ssh_port
}
