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
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gd='git diff'
alias gds='git diff --staged'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate -10'
alias gss='git stash'
alias gsp='git stash pop'
alias gundo='git reset --soft HEAD~1'
alias g='git status'

# Directories
alias mkdir='mkdir -p'
alias md='mkdir -p'

# System
alias df='df -h'
alias du='du -sh'
alias path='echo $PATH | tr ":" "\n"'
alias grep='grep --color=auto'
alias c='clear'

# Safety
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

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
