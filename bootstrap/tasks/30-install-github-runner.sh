#!/usr/bin/env bash

set -euo pipefail

RUNNER_ARCH="$(detect_runner_architecture)"
RUNNER_ARCHIVE="actions-runner-linux-${RUNNER_ARCH}-${GITHUB_RUNNER_VERSION}.tar.gz"
RUNNER_URL="https://github.com/actions/runner/releases/download/v${GITHUB_RUNNER_VERSION}/${RUNNER_ARCHIVE}"

if [[ -f "${GITHUB_RUNNER_DIR}/config.sh" ]]; then
  log_info "GitHub Actions runner déjà présent dans ${GITHUB_RUNNER_DIR}"
else
  log_info "Téléchargement du GitHub Actions runner ${GITHUB_RUNNER_VERSION} (${RUNNER_ARCH})"

  sudo -u "${GITHUB_RUNNER_USER}" bash -c "
    set -euo pipefail
    cd '${GITHUB_RUNNER_DIR}'
    curl -L -o '${RUNNER_ARCHIVE}' '${RUNNER_URL}'
    tar xzf '${RUNNER_ARCHIVE}'
    rm '${RUNNER_ARCHIVE}'
  "
fi

log_info "Installation des dépendances système du runner"
sudo "${GITHUB_RUNNER_DIR}/bin/installdependencies.sh" || true

log_success "GitHub Actions runner installé"