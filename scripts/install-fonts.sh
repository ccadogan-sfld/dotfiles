#!/usr/bin/env bash
set -e

font_already_installed() {
  local font="JetBrainsMonoNerdFont"
  local patterns=(
    "$HOME/Library/Fonts/${font}"*.ttf
    "/Library/Fonts/${font}"*.ttf
    "$HOME/.local/share/fonts/${font}"*.ttf
    "$HOME/.fonts/${font}"*.ttf
  )

  local pattern
  for pattern in "${patterns[@]}"; do
    compgen -G "$pattern" >/dev/null && return 0
  done

  return 1
}

install_jetbrains_mono_nerd_font() {
  echo "Checking for JetBrains Mono Nerd Font..."

  if font_already_installed; then
    echo "JetBrains Mono Nerd Font is already installed."
    return 0
  fi

  if command -v brew >/dev/null; then
    if brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1; then
      echo "JetBrains Mono Nerd Font is already installed via Homebrew."
      return 0
    fi
    echo "Installing JetBrains Mono Nerd Font via Homebrew..."
    brew install --cask font-jetbrains-mono-nerd-font && {
      echo "Font installed successfully via Homebrew."
      return 0
    }
  fi

  if command -v apt-get >/dev/null && command -v apt-cache >/dev/null; then
    echo "Attempting to install via apt..."
    local pkg
    for pkg in \
      fonts-jetbrains-mono-nerd-font \
      fonts-nerd-fonts-jetbrainsmono \
      fonts-nerd-fonts-jetbrains-mono; do
      if apt-cache show "$pkg" >/dev/null 2>&1; then
        echo "Found package: $pkg"
        sudo apt-get install -y "$pkg" && {
          echo "Font installed successfully via apt."
          return 0
        }
      fi
    done
  fi

  command -v git >/dev/null || { echo "git is required to install Nerd Fonts" >&2; return 1; }

  echo "Installing from GitHub repository (this may take a moment)..."
  local repo="https://github.com/ryanoasis/nerd-fonts.git"
  local tmpdir
  tmpdir="$(mktemp -d 2>/dev/null || mktemp -d -t nerd-fonts)"

  { git clone --depth 1 "$repo" "$tmpdir/nerd-fonts" >/dev/null 2>&1 &&
    (cd "$tmpdir/nerd-fonts" && ./install.sh JetBrainsMono >/dev/null 2>&1); }
  local status=$?
  rm -rf "$tmpdir"

  if [ "$status" -eq 0 ]; then
    echo "Font installed successfully from GitHub."
  else
    echo "Failed to install font from GitHub." >&2
  fi

  return "$status"
}

install_jetbrains_mono_nerd_font
