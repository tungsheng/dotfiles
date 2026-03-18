# shellcheck shell=bash
# Shared aliases - sourced by .zshrc and .bashrc

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Listing (OS-aware colors)
if [[ "$OSTYPE" == darwin* ]]; then
  alias ls='ls -G'
else
  alias ls='ls --color=auto'
fi
alias ll='ls -la'
alias la='ls -lathr'

# Editors
alias vim='nvim'
alias v='nvim'

# Git helpers
git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return 1
  local ref
  for ref in refs/heads/{main,master,trunk}; do
    if command git show-ref -q --verify "$ref"; then
      echo "${ref#refs/heads/}"
      return 0
    fi
  done
  echo main
}

# Git aliases
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gbd='git branch --delete'
alias gbD='git branch --delete --force'
alias gbl='git blame -w'
alias gbm='git branch --move'
alias gbr='git branch --remote'
alias gc='git commit'
alias gcam='git commit --all --message'
alias gcb='git checkout -b'
alias gcl='git clone --recurse-submodules'
alias gcm='git commit --message'
alias gco='git checkout'
alias gcom='git checkout $(git_main_branch)'
alias gcp='git cherry-pick'
alias gcv='git commit --verbose'
alias gd='git diff'
alias gl='git pull'
alias gp='git push'
alias gpo='git push origin'
alias gpr='git pull --rebase'
alias gre='git reset'
alias greh='git reset --hard'
alias gres='git reset --soft'
alias gsh='git show'
alias gss='git status --short'
alias gst='git status'
alias gsta='git stash'
alias gstp='git stash pop'

# Directories
alias md='mkdir -p'

# System
alias df='df -h'
alias du='du -sh'
alias path='echo $PATH | tr ":" "\n"'
alias grep='grep --color=auto'
alias c='clear'

# Quick config edits
alias zshrc='${EDITOR:-nvim} ~/.zshrc'
alias bashrc='${EDITOR:-nvim} ~/.bashrc'
alias aliases='${EDITOR:-nvim} ~/.config/shell/aliases.sh'

grt() {
  cd "$(git rev-parse --show-toplevel 2>/dev/null || pwd)" || return 1
}

reload() {
  if [[ -n "${ZSH_VERSION:-}" ]]; then
    # shellcheck source=/dev/null
    source "$HOME/.zshrc"
  elif [[ -n "${BASH_VERSION:-}" ]]; then
    # shellcheck source=/dev/null
    source "$HOME/.bashrc"
  else
    printf 'dotfiles: reload is only supported in bash or zsh\n' >&2
    return 1
  fi
}

# macOS specific
if [[ "$OSTYPE" == darwin* ]]; then
  alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
  alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
fi
