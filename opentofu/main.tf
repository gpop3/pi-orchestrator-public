module "mealie" {
  source = "./modules/mealie"

  data_dir     = var.data_dir
  timezone     = var.timezone
  puid         = var.puid
  pgid         = var.pgid
  image        = var.mealie_image
  port         = var.mealie_port
  base_url     = var.mealie_base_url
  allow_signup = var.mealie_allow_signup
}

module "homeassistant" {
  source = "./modules/homeassistant"

  data_dir      = var.data_dir
  timezone      = var.timezone
  image         = var.homeassistant_image
  zigbee_device = var.zigbee_device
}

module "mqtt" {
  source = "./modules/mqtt"

  data_dir       = var.data_dir
  image          = var.mqtt_image
  mqtt_port      = var.mqtt_port
  websocket_port = var.mqtt_websocket_port
  puid           = var.puid
  pgid           = var.pgid
}

module "node_red" {
  source = "./modules/node-red"

  data_dir = var.data_dir
  timezone = var.timezone
  image    = var.node_red_image
  port     = var.node_red_port
  puid     = var.puid
  pgid     = var.pgid
}

module "decouverte" {
  source = "./modules/1jour1decouverte"

  data_dir           = var.data_dir
  timezone           = var.timezone
  puid               = var.puid
  pgid               = var.pgid
  image              = var.decouverte_image
  container_name     = var.decouverte_container_name
  anthropic_api_key  = var.decouverte_anthropic_api_key
  twilio_account_sid = var.decouverte_twilio_account_sid
  twilio_auth_token  = var.decouverte_twilio_auth_token
  twilio_from        = var.decouverte_twilio_from
  whatsapp_to        = var.decouverte_whatsapp_to
  heure_envoi        = var.decouverte_heure_envoi
}