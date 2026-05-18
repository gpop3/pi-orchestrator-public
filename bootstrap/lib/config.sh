#!/usr/bin/env bash

# GitHub Actions runner
export GITHUB_RUNNER_USER="${GITHUB_RUNNER_USER:-github-runner}"
export GITHUB_RUNNER_DIR="${GITHUB_RUNNER_DIR:-/opt/github-runner}"
export GITHUB_RUNNER_VERSION="${GITHUB_RUNNER_VERSION:-2.334.0}"

# Labels utilisés par le workflow GitHub Actions
export GITHUB_RUNNER_NAME="${GITHUB_RUNNER_NAME:-raspberry-pi}"
export GITHUB_RUNNER_LABELS="${GITHUB_RUNNER_LABELS:-raspberry}"

# Packages strictement nécessaires pour lancer Ansible et installer le runner
# Le reste doit être géré par Ansible
export BOOTSTRAP_PACKAGES="${BOOTSTRAP_PACKAGES:-python3 python3-pip python3-venv git curl ca-certificates ansible}"