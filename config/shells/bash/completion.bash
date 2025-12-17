# Bash completion: bash-completion setup; keep this interactive-only.

# Prefer system bash-completion when available.
if [ -r /etc/bash_completion ]; then
  . /etc/bash_completion
elif [ -r /usr/share/bash-completion/bash_completion ]; then
  . /usr/share/bash-completion/bash_completion
elif command -v brew >/dev/null; then
  brew_prefix="$(brew --prefix 2>/dev/null)"
  if [ -n "$brew_prefix" ] && [ -r "$brew_prefix/etc/profile.d/bash_completion.sh" ]; then
    . "$brew_prefix/etc/profile.d/bash_completion.sh"
  fi
fi

