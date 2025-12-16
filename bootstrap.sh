#!/usr/bin/env bash
set -e

echo "Bootstrapping dotfiles..."

# If invoked via `sh`, we may be running bash in POSIX mode (macOS `/bin/sh`) or a shell that can't
# parse bash features used by this repo (arrays, process substitution). Re-exec under full bash.
if [ -n "${BASH_VERSION:-}" ]; then
  if shopt -oq posix; then
    exec bash "$0" "$@"
  fi
else
  exec bash "$0" "$@"
fi

source "$(dirname "$0")/scripts/bootstrap/lib.sh"

if [[ "$OSTYPE" == "darwin"* ]]; then
  command -v brew >/dev/null || \
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew bundle
elif command -v apt >/dev/null; then
  xargs -a apt.txt sudo apt install -y
elif command -v dnf >/dev/null; then
  xargs -a apt.txt sudo dnf install -y
elif command -v yum >/dev/null; then
  xargs -a apt.txt sudo yum install -y
else
  echo "Unsupported OS"
  exit 1
fi

stow_all


./scripts/curl-installs.sh

echo "Bootstrap complete! Restart your terminal to apply changes."
