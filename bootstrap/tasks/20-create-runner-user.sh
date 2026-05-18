#!/usr/bin/env bash

set -euo pipefail

if id "${GITHUB_RUNNER_USER}" >/dev/null 2>&1; then
  log_info "L'utilisateur ${GITHUB_RUNNER_USER} existe déjà"
else
  log_info "Création de l'utilisateur ${GITHUB_RUNNER_USER}"
  sudo useradd \
    --create-home \
    --shell /bin/bash \
    "${GITHUB_RUNNER_USER}"
fi

log_info "Configuration sudo sans mot de passe pour ${GITHUB_RUNNER_USER}"
echo "${GITHUB_RUNNER_USER} ALL=(ALL) NOPASSWD:ALL" | sudo tee "/etc/sudoers.d/${GITHUB_RUNNER_USER}" >/dev/null
sudo chmod 0440 "/etc/sudoers.d/${GITHUB_RUNNER_USER}"

log_info "Préparation du dossier runner : ${GITHUB_RUNNER_DIR}"
ensure_directory "${GITHUB_RUNNER_DIR}" "${GITHUB_RUNNER_USER}" "${GITHUB_RUNNER_USER}" "0755"

log_success "Utilisateur runner prêt"