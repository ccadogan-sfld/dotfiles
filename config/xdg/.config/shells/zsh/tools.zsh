# Zsh tool init: prompt, direnv/fzf/zoxide hooks, etc; keep interactive-only.

if command -v starship >/dev/null; then
  if [ -z "${STARSHIP_CONFIG:-}" ]; then
    if [ -f "$HOME/.config/starship.toml" ]; then
      export STARSHIP_CONFIG="$HOME/.config/starship.toml"
    elif [ -f "$HOME/.config/starship/starship.toml" ]; then
      export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
    fi
  fi
  eval "$(starship init zsh)"
fi
