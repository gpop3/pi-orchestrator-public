data_dir = "/opt/projets"

timezone = "Europe/Paris"

puid = 1000
pgid = 1000

mealie_image        = "ghcr.io/mealie-recipes/mealie:v3.14.0"
mealie_port         = 9925
mealie_base_url     = "http://localhost:9925"
mealie_allow_signup = true

homeassistant_image = "ghcr.io/home-assistant/home-assistant:2026.3.3"

zigbee_device = "/dev/serial/by-id/usb-ITead_Sonoff_Zigbee_3.0_USB_Dongle_Plus_18fb85990922f0119969678fb887153e-if00-port0"

mqtt_image          = "eclipse-mosquitto:2.0"
mqtt_port           = 1883
mqtt_websocket_port = 9001

node_red_image = "nodered/node-red:4.1.7-minimal"
node_red_port  = 1880


decouverte_heure_envoi = "07:30"
decouverte_image       = "ghcr.io/gpop3/1jour1decouverte:sha-0674fd4"