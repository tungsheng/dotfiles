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
