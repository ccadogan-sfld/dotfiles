# Bash aliases: aliases only; avoid exports, option setting, and tool init.

alias ll='ls -lah'
alias la='ls -lah'
alias vim='nvim'

if command -v kubectl >/dev/null; then
  alias k='kubectl'
fi
