#!/usr/bin/env bash

set -euo pipefail

log_info() {
  echo -e "\033[1;34m[INFO]\033[0m $*"
}

log_success() {
  echo -e "\033[1;32m[SUCCESS]\033[0m $*"
}

log_warn() {
  echo -e "\033[1;33m[WARN]\033[0m $*"
}

log_error() {
  echo -e "\033[1;31m[ERROR]\033[0m $*" >&2
}

log_section() {
  echo ""
  echo -e "\033[1;36m==> $*\033[0m"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

require_root_command() {
  if ! command_exists sudo; then
    log_error "sudo est requis pour exécuter ce bootstrap."
    exit 1
  fi
}

ensure_directory() {
  local directory="$1"
  local owner="${2:-root}"
  local group="${3:-root}"
  local mode="${4:-0755}"

  sudo mkdir -p "${directory}"
  sudo chown "${owner}:${group}" "${directory}"
  sudo chmod "${mode}" "${directory}"
}

detect_runner_architecture() {
  local machine
  machine="$(uname -m)"

  case "${machine}" in
    aarch64)
      echo "arm64"
      ;;
    armv7l)
      echo "arm"
      ;;
    x86_64)
      echo "x64"
      ;;
    *)
      log_error "Architecture non supportée pour GitHub runner : ${machine}"
      exit 1
      ;;
  esac
}