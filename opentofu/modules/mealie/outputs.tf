output "container_name" {
  value = docker_container.this.name
}

output "url" {
  value = var.base_url
}