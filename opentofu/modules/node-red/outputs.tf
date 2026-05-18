output "container_name" {
  value = docker_container.this.name
}

output "url" {
  value = "http://localhost:${var.port}"
}