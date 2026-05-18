#!/usr/bin/env bash

set -euo pipefail

BOOTSTRAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${BOOTSTRAP_DIR}/lib/common.sh"
source "${BOOTSTRAP_DIR}/lib/config.sh"

main() {
  log_section "Pi-Orchestrator bootstrap"

  require_root_command
  run_task "00-preflight.sh"
  run_task "10-install-bootstrap-packages.sh"
  run_task "20-create-runner-user.sh"
  run_task "30-install-github-runner.sh"
  run_task "40-print-next-steps.sh"

  log_success "Bootstrap terminé"
}

run_task() {
  local task_name="$1"
  local task_path="${BOOTSTRAP_DIR}/tasks/${task_name}"

  if [[ ! -f "${task_path}" ]]; then
    log_error "Task introuvable : ${task_path}"
    exit 1
  fi

  log_section "Exécution : ${task_name}"
  # shellcheck source=/dev/null
  source "${task_path}"
}

main "$@"