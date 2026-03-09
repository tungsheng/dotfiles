# shellcheck shell=bash
# ~/.bash_profile - Login shell config (sources .bashrc)

# macOS: Homebrew + terminal defaults
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/platform.sh"
dotfiles_source_homebrew_shellenv

if [[ "$OSTYPE" == darwin* ]]; then
  export TERM=xterm-256color
fi

# Source .bashrc for interactive settings
[[ -n "$BASH_VERSION" && -f "$HOME/.bashrc" ]] && source "$HOME/.bashrc"
