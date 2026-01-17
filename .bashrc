#
# ~/.bashrc
#

# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

# Set to superior editing mode
set -o vi

# Silence macOS bash deprecation warning
if [[ "$OSTYPE" == "darwin"* ]]; then
    export BASH_SILENCE_DEPRECATION_WARNING=1
fi

# Load git prompt if available
if [[ -f ~/.git-prompt.sh ]]; then
    source ~/.git-prompt.sh
fi

# ======== PROMPT =========
export PS1='\[\e[33m\]\u\[\e[0m\]@\[\e[34m\]\h\[\e[0m\]:\[\e[35m\]\W\[\e[0m\] $(__git_ps1 "(%s)") \n$ '

# ======== ALIASES =========
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"

# Git aliases (bash doesn't have OMZP::git like zsh)
alias ga='git add'
alias gb='git branch'
alias gco='git checkout'
alias gcm='git commit -m'
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gst='git status'
alias gss='git stash save'
alias gsp='git stash pop'
alias gmv='git mv'
alias grm='git rm'
alias gundo='git reset --soft HEAD~1'

g() {
  if [[ $# -gt 0 ]]; then
    git "$@"
  else
    git status
  fi
}
