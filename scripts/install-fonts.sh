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
  font_already_installed && return

  if command -v brew >/dev/null; then
    brew list --cask font-jetbrains-mono-nerd-font >/dev/null 2>&1 && return
    brew install --cask font-jetbrains-mono-nerd-font && return
  fi

  if command -v apt-get >/dev/null && command -v apt-cache >/dev/null; then
    local pkg
    for pkg in \
      fonts-jetbrains-mono-nerd-font \
      fonts-nerd-fonts-jetbrainsmono \
      fonts-nerd-fonts-jetbrains-mono; do
      if apt-cache show "$pkg" >/dev/null 2>&1; then
        sudo apt-get install -y "$pkg" && return
      fi
    done
  fi

  command -v git >/dev/null || { echo "git is required to install Nerd Fonts" >&2; return 1; }

  local repo="https://github.com/ryanoasis/nerd-fonts.git"
  local tmpdir
  tmpdir="$(mktemp -d 2>/dev/null || mktemp -d -t nerd-fonts)"

  { git clone --depth 1 "$repo" "$tmpdir/nerd-fonts" &&
    (cd "$tmpdir/nerd-fonts" && ./install.sh JetBrainsMono); }
  local status=$?
  rm -rf "$tmpdir"
  return "$status"
}

install_jetbrains_mono_nerd_font
