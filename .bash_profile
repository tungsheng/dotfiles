# ~/.bash_profile - Login shell config (sources .bashrc)

# macOS: Homebrew
if [[ "$OSTYPE" == darwin* ]]; then
  if [[ -f /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -f /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi
  export TERM=xterm-256color
fi

# Source .bashrc for interactive settings
[[ -n "$BASH_VERSION" && -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
