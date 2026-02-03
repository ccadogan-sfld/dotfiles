#!/usr/bin/env bash
set -euo pipefail

install_lazyvim() {
  command -v nvim >/dev/null || return
  if [[ ! -d "$HOME/.local/share/nvim/lazy" ]]; then
    echo "Installing LazyVim requirements..."
    nvim --headless -c '+Lazy! sync' +qa 2>/dev/null || true
  fi
}

install_lazyvim
