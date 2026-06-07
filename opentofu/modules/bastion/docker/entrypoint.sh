#!/usr/bin/env bash
set -e

ssh-keygen -A

[ -f /home/jump/.ssh/authorized_keys ] && {
  chown jump:jump /home/jump/.ssh/authorized_keys
  chmod 600 /home/jump/.ssh/authorized_keys
}
[ -f /home/jump/.google_authenticator ] && {
  chown jump:jump /home/jump/.google_authenticator
  chmod 600 /home/jump/.google_authenticator
}

echo "${WEBHOOK_URL:-}" > /etc/sec-webhook-url
chmod 644 /etc/sec-webhook-url

exec /usr/sbin/sshd -D -e
