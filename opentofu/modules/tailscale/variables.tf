variable "data_dir" {
  type = string
}

variable "image" {
  description = "Image Tailscale"
  type        = string
  default     = "tailscale/tailscale:latest"
}

variable "hostname" {
  description = "Nom du nœud sur le tailnet (MagicDNS)"
  type        = string
  default     = "maison"
}

variable "authkey" {
  description = "Auth key Tailscale (tskey-auth-...)"
  type        = string
  sensitive   = true
}

variable "edge_network" {
  description = "Réseau partagé avec nginx uniquement"
  type        = string
}

variable "nginx_target" {
  description = "Cible nginx (nom:port sur edge)"
  type        = string
  default     = "rev-proxy:80"
}
