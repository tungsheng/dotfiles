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

# NVM setup (supports both ~/.nvm and XDG locations)
if [[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/nvm" ]]; then
  export NVM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvm"
elif [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
fi

# Add default node to PATH immediately (for tools like Mason)
if [[ -n "$NVM_DIR" && -d "$NVM_DIR/versions/node" ]]; then
  _nvm_resolve_default() {
    local alias_file="$NVM_DIR/alias/default"
    local version=""
    if [[ -f "$alias_file" ]]; then
      version=$(cat "$alias_file")
      while [[ -f "$NVM_DIR/alias/$version" ]]; do
        version=$(cat "$NVM_DIR/alias/$version")
      done
    fi
    if [[ ! -d "$NVM_DIR/versions/node/$version" ]]; then
      version=$(ls -1 "$NVM_DIR/versions/node" 2>/dev/null | sort -V | tail -1)
    fi
    echo "$version"
  }
  _nvm_default=$(_nvm_resolve_default)
  [[ -n "$_nvm_default" ]] && export PATH="$NVM_DIR/versions/node/$_nvm_default/bin:$PATH"
  unset -f _nvm_resolve_default
  unset _nvm_default
fi

# Lazy load full NVM
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}
