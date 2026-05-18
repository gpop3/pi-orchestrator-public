output "container_name" {
  value = docker_container.this.name
}

output "mqtt_url" {
  value = "mqtt://localhost:${var.mqtt_port}"
}

output "websocket_url" {
  value = "ws://localhost:${var.websocket_port}"
}