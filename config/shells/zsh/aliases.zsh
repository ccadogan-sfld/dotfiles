# Zsh aliases: aliases only; avoid exports, tool init, and long-running commands.

alias ll='ls -lah'
alias la='ls -lah'
alias vim='nvim'

if command -v kubectl >/dev/null; then
  alias k='kubectl'
fi
