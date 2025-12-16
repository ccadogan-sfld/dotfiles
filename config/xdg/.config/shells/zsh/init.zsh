# Zsh interactive init: sourced for interactive shells; should only source peer scripts and interactive-only setup.

ZSH_SHELL_DIR="${${(%):-%x}:A:h}"

source "$ZSH_SHELL_DIR/options.zsh"
source "$ZSH_SHELL_DIR/completion.zsh"
source "$ZSH_SHELL_DIR/functions.zsh"
source "$ZSH_SHELL_DIR/aliases.zsh"
source "$ZSH_SHELL_DIR/tools.zsh"
