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

# Git
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gd='git diff'
alias gl='git pull --ff-only'
alias gp='git push'
alias gst='git status -sb'

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
    source "$HOME/.zshrc"
  elif [[ -n "${BASH_VERSION:-}" ]]; then
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
