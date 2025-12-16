# Bash entrypoint (owned by dotfiles): keep small; source modular config under ~/.config/shells/bash.

BASH_SHELL_DIR="$HOME/.config/shells/bash"

[ -f "$BASH_SHELL_DIR/env.bash" ] && . "$BASH_SHELL_DIR/env.bash"

case $- in
  *i*) [ -f "$BASH_SHELL_DIR/init.bash" ] && . "$BASH_SHELL_DIR/init.bash" ;;
esac

