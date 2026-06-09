#!/usr/bin/env bash
set -e

SSH_DIR="/home/jump/.ssh"
AUTHKEYS="$SSH_DIR/authorized_keys"
OTP_FILE="/home/jump/otp/.google_authenticator"

log() { echo "[bastion] $*"; }

ssh-keygen -A

if [ -n "${ADMIN_PUBKEY:-}" ]; then
  if [ -w "$AUTHKEYS" ] || [ -w "$SSH_DIR" ]; then
    mkdir -p "$SSH_DIR"
    touch "$AUTHKEYS"
    if ! grep -qF "$ADMIN_PUBKEY" "$AUTHKEYS" 2>/dev/null; then
      echo "$ADMIN_PUBKEY" >> "$AUTHKEYS"
      log "Clé ADMIN_PUBKEY ajoutée à authorized_keys."
    fi
  else
    log "ADMIN_PUBKEY fourni mais authorized_keys est en lecture seule."
  fi
fi

if [ ! -s "$AUTHKEYS" ]; then
  log "###############################################################"
  log "#  AUCUNE CLE -> connexion IMPOSSIBLE.                         #"
  log "###############################################################"
  log "1) Sur ton PC, génère une clé :"
  log "     ssh-keygen -t ed25519 -C bastion"
  log "2) Affiche la clé publique :"
  log "     cat ~/.ssh/id_ed25519.pub"
  log "3) Ajoute-la côté hôte du Pi :"
  log "     cat ~/.ssh/id_ed25519.pub | sudo tee -a /opt/projets/bastion/authorized_keys"
  log "   (ou passe-la via la variable Tofu admin_pubkey)"
  log "###############################################################"
fi

mkdir -p /home/jump/otp
chown jump:jump /home/jump/otp 2>/dev/null || true
chmod 700 /home/jump/otp 2>/dev/null || true
if [ -f "$OTP_FILE" ]; then
  chown jump:jump "$OTP_FILE" 2>/dev/null || true
  chmod 600 "$OTP_FILE" 2>/dev/null || true
fi

if [ ! -s "$OTP_FILE" ]; then
  log "***************************************************************"
  log "*  2FA (TOTP) NON ENROLE.  *"
  log "*  Procedure complete pour activer le 2e facteur :            *"
  log "***************************************************************"
  log ""
  log " ETAPE 1 — Installe une app d'authentification sur ton tel :"
  log "   Aegis (Android, open-source), Google Authenticator, ou 2FAS"
  log ""
  log " ETAPE 2 — Lance l'enrolement (sur le Pi, mode interactif) :"
  log "   docker exec -it bastion su - jump -c \\"
  log "     \"HOME=/home/jump/otp google-authenticator -t -d -f -r 3 -R 30 -w 3\""
  log ""
  log " ETAPE 3 — Dans la sortie de cette commande :"
  log "   - SCANNE le QR code avec ton app (ajouter un compte > scan)"
  log "   - si le QR ne passe pas, saisis la cle secrete affichee"
  log "   - NOTE les codes de secours (emergency scratch codes) et"
  log "     range-les en lieu sur : ils te sauvent si tu perds le tel"
  log ""
  log " ETAPE 4 — TESTE sans fermer ta session actuelle :"
  log "   ssh -p 2222 jump@<nom-tailnet-du-pi>"
  log "   -> la cle passe, puis 'Verification code:' = tape le code"
  log "      a 6 chiffres de ton app. Si ca entre, le 2FA marche."
  log "***************************************************************"
else
  log "2FA (TOTP) enrole : authentification cle + code active. OK"
fi

echo "${WEBHOOK_URL:-}"   > /etc/sec-webhook-url
echo "${WEBHOOK_TOKEN:-}" > /etc/sec-webhook-token
chmod 644 /etc/sec-webhook-url /etc/sec-webhook-token

log "Demarrage de sshd"
exec /usr/sbin/sshd -D -e
