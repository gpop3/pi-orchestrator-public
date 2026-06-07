#!/usr/bin/env bash
set -e

ssh-keygen -A

if [ -f /home/jump/.google_authenticator ] && [ -w /home/jump/.google_authenticator ]; then
  chown jump:jump /home/jump/.google_authenticator 2>/dev/null || true
  chmod 600 /home/jump/.google_authenticator 2>/dev/null || true
fi

echo "${WEBHOOK_URL:-}"   > /etc/sec-webhook-url
echo "${WEBHOOK_TOKEN:-}" > /etc/sec-webhook-token
chmod 644 /etc/sec-webhook-url /etc/sec-webhook-token

exec /usr/sbin/sshd -D -e
