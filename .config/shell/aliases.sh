# Shared shell aliases (sourced by both .zshrc and .bashrc)

# Navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Listing
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias ls='ls -G'
else
    alias ls='ls --color=auto'
fi
alias ll='ls -la'
alias la='ls -lathr'

# Editors
alias vim='nvim'
alias v='nvim'

# Utilities
alias c='clear'

# Git shortcuts
alias gs='git status'
alias gd='git diff'
alias gds='git diff --staged'
alias ga='git add'
alias gc='git commit'
alias gcm='git commit -m'
alias gp='git push'
alias gl='git pull'
alias gco='git checkout'
alias gb='git branch'
alias glog='git log --oneline --graph --decorate -10'

# Directory creation
alias mkdir='mkdir -p'
alias md='mkdir -p'

# System info
alias df='df -h'
alias du='du -sh'
alias path='echo $PATH | tr ":" "\n"'

# Safety nets
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Quick edits
alias zshrc='${EDITOR:-nvim} ~/.zshrc'
alias bashrc='${EDITOR:-nvim} ~/.bashrc'
alias aliases='${EDITOR:-nvim} ~/.config/shell/aliases.sh'

# Reload shell config
alias reload='source ~/.${SHELL##*/}rc'

# Grep with color
alias grep='grep --color=auto'

# Show/hide hidden files in Finder (macOS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    alias showfiles='defaults write com.apple.finder AppleShowAllFiles YES; killall Finder'
    alias hidefiles='defaults write com.apple.finder AppleShowAllFiles NO; killall Finder'
fi
