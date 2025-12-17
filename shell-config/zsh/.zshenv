# Zsh entrypoint: keep fast/safe; source env for all shells and interactive init only when interactive.

ZSH_SHELL_DIR="$HOME/.config/shells/zsh"

if [ -f "$ZSH_SHELL_DIR/env.zsh" ]; then
  . "$ZSH_SHELL_DIR/env.zsh"
fi

case $- in
  *i*)
    if [ -f "$ZSH_SHELL_DIR/init.zsh" ]; then
      . "$ZSH_SHELL_DIR/init.zsh"
    fi
    ;;
esac
