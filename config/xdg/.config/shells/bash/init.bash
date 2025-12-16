# Bash interactive init: sourced for interactive shells; should only source peer scripts and interactive-only setup.

BASH_SHELL_DIR="$HOME/.config/shells/bash"

. "$BASH_SHELL_DIR/options.bash"
. "$BASH_SHELL_DIR/completion.bash"
. "$BASH_SHELL_DIR/functions.bash"
. "$BASH_SHELL_DIR/aliases.bash"
. "$BASH_SHELL_DIR/tools.bash"

