# Bash options: set/shopt, history, keybindings; avoid exports and tool initialization.

# History behavior (interactive shells only via init loader).
HISTSIZE=5000
HISTFILESIZE=10000
shopt -s histappend

# Keep window size variables up to date.
shopt -s checkwinsize

