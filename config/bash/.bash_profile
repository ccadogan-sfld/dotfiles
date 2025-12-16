# Bash login entrypoint (owned by dotfiles): load interactive config via ~/.bashrc.

[ -f "$HOME/.bashrc" ] && . "$HOME/.bashrc"

