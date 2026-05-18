output "container_name" {
  value = docker_container.this.name
}

output "url" {
  value = "http://localhost:8123"
}