#!/usr/bin/env bash
set -e

install_starship() {
  command -v starship >/dev/null && return
  curl -fsSL https://starship.rs/install.sh | sh -s -- -y
}

install_uv() {
    command -v uv >/dev/null && return
    curl -LsSf https://astral.sh/uv/install.sh | sh
}

install_starship
install_uv
