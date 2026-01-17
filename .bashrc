# ~/.bashrc

# Exit if not interactive
[[ $- != *i* ]] && return

# Vi mode
set -o vi

# macOS: silence bash deprecation warning
[[ "$OSTYPE" == "darwin"* ]] && export BASH_SILENCE_DEPRECATION_WARNING=1

# Git prompt
[[ -f ~/.git-prompt.sh ]] && source ~/.git-prompt.sh

# Prompt
PS1='\[\e[33m\]\u\[\e[0m\]@\[\e[34m\]\h\[\e[0m\]:\[\e[35m\]\W\[\e[0m\]$(__git_ps1 " (%s)") \n$ '

# Aliases
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"

# Git aliases (zsh uses OMZP::git)
alias ga='git add'
alias gb='git branch'
alias gco='git checkout'
alias gcm='git commit -m'
alias gl='git pull'
alias gp='git push'
alias gd='git diff'
alias gst='git status'
alias gss='git stash'
alias gsp='git stash pop'
alias gundo='git reset --soft HEAD~1'

g() { [[ $# -gt 0 ]] && git "$@" || git status; }
