output "container_name" {
  value = docker_container.this.name
}

output "image" {
  value = docker_image.this.name
}

output "data_path" {
  value = "${var.data_dir}/1jour1decouverte/data"
}