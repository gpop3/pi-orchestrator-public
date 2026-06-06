variable "data_dir" {
  type = string
}

variable "image" {
  description = "Image nginx"
  type        = string
  default     = "nginx:stable-alpine"
}

variable "port" {
  description = "Port hôte exposé par nginx (accès LAN)"
  type        = number
  default     = 80
}

variable "edge_network" {
  description = "Réseau partagé avec tailscale"
  type        = string
}

variable "backend_network" {
  description = "Réseau partagé avec HA et les autres services"
  type        = string
}

variable "ha_upstream" {
  description = "Cible HA (nom de conteneur:port sur backend)"
  type        = string
  default     = "homeassistant:8123"
}
