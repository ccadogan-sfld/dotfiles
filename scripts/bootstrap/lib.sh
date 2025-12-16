#!/usr/bin/env bash
set -e

# Backup a conflicting target path in $HOME before stowing (moves the entire path aside).
backup_path() {
  local path="$1"
  if [ ! -e "$path" ] && [ ! -L "$path" ]; then
    return
  fi

  local suffix=".pre-stow.$(date +%s)"
  local backup="${path}${suffix}"
  while [ -e "$backup" ] || [ -L "$backup" ]; do
    suffix=".pre-stow.$(date +%s)"
    backup="${path}${suffix}"
  done
  echo "Preserving existing $path as $backup"
  mv "$path" "$backup"
}

dotfiles_realpath() {
  local path="$1"
  if command -v python3 >/dev/null 2>&1; then
    python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$path"
  else
    echo "$path"
  fi
}

maybe_backup_conflict() {
  local dest="$1"
  local expected_source="$2"

  if [ -L "$dest" ] && [ -n "$expected_source" ]; then
    local resolved
    resolved="$(dotfiles_realpath "$dest")"
    if [ "$resolved" = "$expected_source" ]; then
      return
    fi
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    backup_path "$dest"
  fi
}

# Stow all packages under ./config into $HOME, backing up any conflicting existing files first.
stow_all() {
  if [ ! -d config ] || [ -z "$(find config -mindepth 1 -print -quit 2>/dev/null)" ]; then
    echo "No dotfiles found under config/; skipping stow."
    return 0
  fi

  if ! command -v stow >/dev/null; then
    echo "Stow is missing; install it and rerun bootstrap."
    return 0
  fi

  # Migration: earlier layout incorrectly stowed `.config/*` into `$HOME/*` (e.g. `$HOME/shells`).
  local legacy
  for legacy in git nvim shells starship tmux vim; do
    local legacy_path="$HOME/$legacy"
    if [ -L "$legacy_path" ]; then
      local legacy_target
      legacy_target="$(readlink "$legacy_path" 2>/dev/null || true)"
      if [[ "$legacy_target" == *"/config/.config/$legacy" ]]; then
        echo "Removing legacy symlink $legacy_path -> $legacy_target"
        rm "$legacy_path"
      fi
    fi
  done

  local dotfiles_root
  dotfiles_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd -P)"

  local stow_packages=()
  local pkg
  local pkg_base
  shopt -s dotglob nullglob
  for pkg in config/*; do
    [ -d "$pkg" ] || continue
    pkg_base="$(basename "$pkg")"
    [ "$pkg_base" = ".config" ] && continue
    stow_packages+=("$pkg_base")
  done
  shopt -u dotglob nullglob

  if [ ${#stow_packages[@]} -eq 0 ]; then
    echo "No stow packages found under config/; nothing to link."
    return 0
  fi

  # Backup conflicts at the directory/file level we intend to link, to allow directory symlinks.
  for pkg in "${stow_packages[@]}"; do
    if [ "$pkg" = "xdg" ]; then
      local name
      shopt -s dotglob nullglob
      for entry in config/xdg/.config/*; do
        [ -e "$entry" ] || continue
        name="$(basename "$entry")"
        maybe_backup_conflict "$HOME/.config/$name" "$dotfiles_root/config/xdg/.config/$name"
      done
      shopt -u dotglob nullglob
      continue
    fi

    local name
    shopt -s dotglob nullglob
    for entry in "config/$pkg"/*; do
      [ -e "$entry" ] || continue
      name="$(basename "$entry")"
      maybe_backup_conflict "$HOME/$name" "$dotfiles_root/config/$pkg/$name"
    done
    shopt -u dotglob nullglob
  done

  stow -d config -t "$HOME" "${stow_packages[@]}"
}
