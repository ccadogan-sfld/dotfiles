#!/usr/bin/env bash
set -euo pipefail

install_lazyvim() {
  command -v nvim >/dev/null || return
  if [[ ! -d "$HOME/.local/share/nvim/lazy" ]]; then
    echo "Installing LazyVim requirements..."
    nvim --headless -c '+Lazy! sync' +qa 2>/dev/null || true
  fi

warn_if_missing() {
  local missing=0

  for cmd in git nvim rg fd; do
    command -v "$cmd" >/dev/null 2>&1 || { echo "LazyVim prerequisite missing: $cmd" >&2; missing=1; }
  done

  command -v cc >/dev/null 2>&1 || {
    echo "LazyVim note: a C compiler (cc/clang/gcc) is recommended for Treesitter." >&2
    missing=1
  }

  return "$missing"
}

if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
  mkdir -p "$HOME/bin"
  target="$HOME/bin/fd"
  if [ ! -e "$target" ] && [ ! -L "$target" ]; then
    ln -s "$(command -v fdfind)" "$target"
    echo "Linked fd -> fdfind at $target"
  fi
fi

warn_if_missing || true
