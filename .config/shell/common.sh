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

# Bash only (zsh loads zoxide at the end of ~/.zshrc). Kept outside the `[ -t 0 ]`
# fzf block so tmux / some terminals still hook `cd` when stdin looks non-TTY.
dotfiles_bash_zoxide_init() {
  command -v zoxide >/dev/null || return 0
  eval "$(zoxide init --cmd cd bash)"
  alias z=__zoxide_z
}

# Safety aliases (interactive shell only)
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Shared config
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/nvm.sh"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env-loader.sh"

# ~/.env before fzf/zoxide (PATH, _ZO_DATA_DIR, etc.)
load_home_env_files "$HOME"

export BUN_INSTALL="$HOME/.bun"
dotfiles_prepend_path_if_dir "$BUN_INSTALL/bin"
dotfiles_prepend_path_if_dir "$HOME/.local/bin"

if [ -t 0 ]; then
  case "$(dotfiles_current_shell 2>/dev/null)" in
    zsh)
      command -v fzf >/dev/null && eval "$(fzf --zsh)"
      ;;
    bash)
      command -v fzf >/dev/null && eval "$(fzf --bash)"
      ;;
  esac
fi

case "$(dotfiles_current_shell 2>/dev/null)" in
  bash) dotfiles_bash_zoxide_init ;;
esac
