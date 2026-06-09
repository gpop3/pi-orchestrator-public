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

variable "tailnet_port" {
  description = "Port d'ecoute INTERNE pour la zone tailnet (cible de Tailscale Serve). Non publie sur l'hote."
  type        = number
  default     = 8080
}

variable "ha_upstream" {
  description = "Cible HA. HA étant en host mode."
  type        = string
  default     = "host.docker.internal:8123"
}

variable "mealie_upstream" {
  description = "Cible Mealie (nom de conteneur sur backend)"
  type        = string
  default     = "mealie:9000"
}

variable "nodered_upstream" {
  description = "Cible Node-RED (nom de conteneur sur backend)"
  type        = string
  default     = "nodered:1880"
}

variable "ha_domain" {
  description = "Sous-domaine LAN pour Home Assistant"
  type        = string
  default     = "maison.local"
}

variable "mealie_domain" {
  description = "Sous-domaine LAN pour Mealie"
  type        = string
  default     = "mealie.maison.local"
}

variable "nodered_domain" {
  description = "Sous-domaine LAN pour Node-RED"
  type        = string
  default     = "nodered.maison.local"
}

variable "edge_ip" {
  description = "IP fixe de nginx sur le reseau edge"
  type        = string
  default     = "172.18.0.10"
}

variable "backend_ip" {
  description = "IP fixe de nginx sur le reseau backend"
  type        = string
  default     = "172.19.0.10"
}
