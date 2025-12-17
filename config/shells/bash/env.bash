# Bash environment: exports and PATH that should be safe/fast; avoid aliases, shopt/set, and tool init.

# Prefer Neovim as the default editor so CLI tools respect it.
export EDITOR="nvim"
export VISUAL="$EDITOR"

# Add a personal bin directory early on the PATH.
export PATH="$HOME/bin:$PATH"

# Ensure starship uses the config installed by these dotfiles.
if [ -z "${STARSHIP_CONFIG:-}" ]; then
  export STARSHIP_CONFIG="$HOME/.config/starship.toml"
fi
