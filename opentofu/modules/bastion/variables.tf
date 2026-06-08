variable "data_dir" {
  type = string
}

variable "ssh_port" {
  description = "Port SSH du bastion publié sur l'hôte (via tailnet)"
  type        = number
  default     = 2222
}

variable "edge_network" {
  description = "Réseau Docker du bastion"
  type        = string
}

variable "webhook_url" {
  description = "URL du webhook HA pour notifier les logins bastion"
  type        = string
  default     = ""
}

variable "webhook_token" {
  description = "Token Bearer pour l'API de notification"
  type        = string
  default     = ""
  sensitive   = true
}

variable "admin_pubkey" {
  description = "Clé publique SSH de l'admin"
  type        = string
  default     = ""
}
