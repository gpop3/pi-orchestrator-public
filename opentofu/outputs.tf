output "mealie_url" {
  description = "Mealie URL"
  value       = module.mealie.url
}

output "homeassistant_url" {
  description = "Home Assistant URL"
  value       = module.homeassistant.url
}

output "mqtt_url" {
  description = "MQTT broker URL"
  value       = module.mqtt.mqtt_url
}

output "mqtt_websocket_url" {
  description = "MQTT WebSocket URL"
  value       = module.mqtt.websocket_url
}

output "node_red_url" {
  description = "Node-RED URL"
  value       = module.node_red.url
}

output "container_names" {
  description = "Managed container names"
  value = [
    module.mealie.container_name,
    module.homeassistant.container_name,
    module.mqtt.container_name,
    module.node_red.container_name
  ]
}

output "decouverte_container_name" {
  value = module.decouverte.container_name
}

output "decouverte_data_path" {
  value = module.decouverte.data_path
}