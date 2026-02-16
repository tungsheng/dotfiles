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
alias reload='source ~/.${SHELL##*/}rc'

# macOS specific
if [[ "$OSTYPE" == darwin* ]]; then
  alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
  alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
fi
