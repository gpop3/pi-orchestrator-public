#!/usr/bin/env bash

set -euo pipefail

log_info "Mise à jour minimale du cache apt"
sudo apt-get update

log_info "Installation des packages strictement nécessaires au bootstrap"
# shellcheck disable=SC2086
sudo apt-get install -y ${BOOTSTRAP_PACKAGES}

log_info "Versions installées"
python3 --version
git --version
ansible --version

log_success "Packages bootstrap installés"