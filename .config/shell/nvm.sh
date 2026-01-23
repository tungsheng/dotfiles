# NVM setup - shared between zsh and bash
# Supports both ~/.nvm and XDG locations

# Detect NVM directory (prefer XDG, fallback to traditional)
if [[ -d "${XDG_DATA_HOME:-$HOME/.local/share}/nvm" ]]; then
  export NVM_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvm"
elif [[ -d "$HOME/.nvm" ]]; then
  export NVM_DIR="$HOME/.nvm"
fi

# Add default node to PATH immediately (for tools like Mason)
# This avoids full NVM load while ensuring node/npm is available
if [[ -n "$NVM_DIR" && -d "$NVM_DIR/versions/node" ]]; then
  _nvm_resolve_default() {
    local alias_file="$NVM_DIR/alias/default"
    local version=""
    if [[ -f "$alias_file" ]]; then
      version=$(cat "$alias_file")
      # Resolve alias chain (lts/* -> lts/iron -> v20.x.x)
      while [[ -f "$NVM_DIR/alias/$version" ]]; do
        version=$(cat "$NVM_DIR/alias/$version")
      done
    fi
    # Fallback to latest installed version
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
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  [[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"
  nvm "$@"
}
