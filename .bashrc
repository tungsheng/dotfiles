# ~/.bashrc - Bash configuration

# Exit if not interactive
[[ $- != *i* ]] && return

# macOS: silence bash deprecation warning
[[ "$OSTYPE" == darwin* ]] && export BASH_SILENCE_DEPRECATION_WARNING=1

# Emacs mode
set -o emacs

# History
HISTSIZE=5000
HISTFILESIZE=5000
HISTCONTROL=ignoreboth:erasedups

# Git prompt (XDG location)
if [[ -f "${XDG_DATA_HOME:-$HOME/.local/share}/git/git-prompt.sh" ]]; then
  source "${XDG_DATA_HOME:-$HOME/.local/share}/git/git-prompt.sh"
  PS1='\[\e[33m\]\u\[\e[0m\]@\[\e[34m\]\h\[\e[0m\]:\[\e[35m\]\W\[\e[0m\]$(__git_ps1 " (%s)") \n$ '
else
  PS1='\[\e[33m\]\u\[\e[0m\]@\[\e[34m\]\h\[\e[0m\]:\[\e[35m\]\W\[\e[0m\] \n$ '
fi

# Safety aliases (interactive shell only)
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Shared config
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/nvm.sh"

# Shell integrations
command -v fzf >/dev/null && eval "$(fzf --bash)"
command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd bash)"

# Bun
export BUN_INSTALL="$HOME/.bun"
[[ -d "$BUN_INSTALL" ]] && export PATH="$BUN_INSTALL/bin:$PATH"

# uv (Python)
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# Source environment secrets (API keys)
# WARNING: This file is sourced as shell code. Only put 'export VAR=value' lines in it.
[ -f ~/.env.secrets ] && source ~/.env.secrets
