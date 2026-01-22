# Powerlevel10k instant prompt (keep at top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew (macOS)
[[ -f "/opt/homebrew/bin/brew" ]] && eval "$(/opt/homebrew/bin/brew shellenv)"

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

# Plugins
zinit ice depth=1; zinit light romkatv/powerlevel10k
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

# Oh-My-Zsh snippets
zinit snippet OMZP::git
zinit snippet OMZP::sudo
zinit snippet OMZP::aws
zinit snippet OMZP::kubectl
zinit snippet OMZP::kubectx
zinit snippet OMZP::command-not-found

# Docker CLI completions (must be before compinit)
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)

# Completions
autoload -Uz compinit && compinit
zinit cdreplay -q

# Powerlevel10k config
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History (XDG-compliant)
HISTSIZE=5000
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
[[ -d "${HISTFILE%/*}" ]] || mkdir -p "${HISTFILE%/*}"
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shared aliases
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# NVM setup (supports both ~/.nvm and XDG locations)
# Detect NVM directory (prefer XDG, fallback to traditional)
if [[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/nvm" ]]; then
  export NVM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvm"
elif [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
fi

# Add default node to PATH immediately (for tools like Mason)
# This avoids full NVM load while ensuring npm is available
if [[ -n "$NVM_DIR" && -d "$NVM_DIR/versions/node" ]]; then
  # Try to resolve default version (handles aliases like lts/*, default, etc.)
  _nvm_resolve_default() {
    local alias_file="$NVM_DIR/alias/default"
    local version=""
    if [[ -f "$alias_file" ]]; then
      version=$(cat "$alias_file")
      # If it's an alias (like lts/*), try to resolve it
      while [[ -f "$NVM_DIR/alias/$version" ]]; do
        version=$(cat "$NVM_DIR/alias/$version")
      done
    fi
    # If still not a version, find the latest installed
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

# Lazy load full NVM (for nvm use, nvm install, etc.)
nvm() {
  unset -f nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}

# Bun (lazy loaded for faster shell startup)
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
bun() {
  unset -f bun bunx
  [ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
  bun "$@"
}
bunx() { bun; bunx "$@"; }
