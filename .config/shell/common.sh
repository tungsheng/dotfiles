# shellcheck shell=bash
# Shared interactive shell setup for bash and zsh.

dotfiles_current_shell() {
  if [ -n "${ZSH_VERSION:-}" ]; then
    printf '%s' "zsh"
  elif [ -n "${BASH_VERSION:-}" ]; then
    printf '%s' "bash"
  else
    return 1
  fi
}

dotfiles_prepend_path_if_dir() {
  [ -d "$1" ] || return 0

  case ":$PATH:" in
    *":$1:"*) ;;
    *) export PATH="$1:$PATH" ;;
  esac
}

# Safety aliases (interactive shell only)
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Shared config
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/nvm.sh"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env-loader.sh"

# Shell integrations
if [ -t 0 ] && [ -t 1 ]; then
  case "$(dotfiles_current_shell 2>/dev/null)" in
    zsh)
      command -v fzf >/dev/null && eval "$(fzf --zsh)"
      command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"
      ;;
    bash)
      command -v fzf >/dev/null && eval "$(fzf --bash)"
      command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd bash)"
      ;;
  esac
fi

# Bun
export BUN_INSTALL="$HOME/.bun"
dotfiles_prepend_path_if_dir "$BUN_INSTALL/bin"

# uv (Python)
dotfiles_prepend_path_if_dir "$HOME/.local/bin"

# Environment files
load_home_env_files "$HOME"
