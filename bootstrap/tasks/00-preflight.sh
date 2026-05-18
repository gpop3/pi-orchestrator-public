#!/usr/bin/env bash

set -euo pipefail

log_info "Utilisateur courant : $(whoami)"
log_info "Hostname : $(hostname)"
log_info "Architecture : $(uname -m)"
log_info "OS : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
