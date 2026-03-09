# Zsh-specific interactive shell setup.

DOTFILES_ZSH_PLUGIN_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/zsh/plugins"
DOTFILES_ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
DOTFILES_ZSH_COMPLETIONS_DIR="$DOTFILES_ZSH_CACHE_DIR/completions"

dotfiles_zsh_source_if_exists() {
  [[ -f "$1" ]] && source "$1"
}

dotfiles_zsh_add_fpath() {
  local dir="$1"
  local entry

  [[ -d "$dir" ]] || return 0

  for entry in "${fpath[@]}"; do
    [[ "$entry" == "$dir" ]] && return 0
  done

  fpath=("$dir" $fpath)
}

dotfiles_zsh_prepare_plugins() {
  typeset -g ZSH_CACHE_DIR="$DOTFILES_ZSH_CACHE_DIR"
  [[ -d "$DOTFILES_ZSH_COMPLETIONS_DIR" ]] || mkdir -p "$DOTFILES_ZSH_COMPLETIONS_DIR" 2>/dev/null

  dotfiles_zsh_add_fpath "$DOTFILES_ZSH_COMPLETIONS_DIR"
  dotfiles_zsh_add_fpath "$HOME/.docker/completions"

  dotfiles_zsh_source_if_exists "$DOTFILES_ZSH_PLUGIN_DIR/powerlevel10k/powerlevel10k.zsh-theme"
  dotfiles_zsh_source_if_exists "$DOTFILES_ZSH_PLUGIN_DIR/zsh-completions/zsh-completions.plugin.zsh"
}

dotfiles_zsh_enable_sudo_shortcut() {
  __sudo_replace_buffer() {
    local old="$1" new="$2" space=${2:+ }

    if [[ $CURSOR -le ${#old} ]]; then
      BUFFER="${new}${space}${BUFFER#$old }"
      CURSOR=${#new}
    else
      LBUFFER="${new}${space}${LBUFFER#$old }"
    fi
  }

  sudo-command-line() {
    [[ -z $BUFFER ]] && LBUFFER="$(fc -ln -1)"

    local whitespace=""
    if [[ ${LBUFFER:0:1} == " " ]]; then
      whitespace=" "
      LBUFFER="${LBUFFER:1}"
    fi

    {
      local editor="${SUDO_EDITOR:-${VISUAL:-$EDITOR}}"

      if [[ -z "$editor" ]]; then
        case "$BUFFER" in
          sudo\ -e\ *) __sudo_replace_buffer "sudo -e" "" ;;
          sudo\ *) __sudo_replace_buffer "sudo" "" ;;
          *) LBUFFER="sudo $LBUFFER" ;;
        esac
        return
      fi

      local cmd="${${(Az)BUFFER}[1]}"
      local realcmd="${${(Az)aliases[$cmd]}[1]:-$cmd}"
      local editorcmd="${${(Az)editor}[1]}"

      if [[ "$realcmd" = (\$EDITOR|$editorcmd|${editorcmd:c}) \
        || "${realcmd:c}" = ($editorcmd|${editorcmd:c}) ]] \
        || builtin which -a "$realcmd" | command grep -Fx -q "$editorcmd"; then
        __sudo_replace_buffer "$cmd" "sudo -e"
        return
      fi

      case "$BUFFER" in
        $editorcmd\ *) __sudo_replace_buffer "$editorcmd" "sudo -e" ;;
        \$EDITOR\ *) __sudo_replace_buffer '$EDITOR' "sudo -e" ;;
        sudo\ -e\ *) __sudo_replace_buffer "sudo -e" "$editor" ;;
        sudo\ *) __sudo_replace_buffer "sudo" "" ;;
        *) LBUFFER="sudo $LBUFFER" ;;
      esac
    } always {
      LBUFFER="${whitespace}${LBUFFER}"
      zle && zle redisplay
    }
  }

  zle -N sudo-command-line
  bindkey -M emacs '\e\e' sudo-command-line
  bindkey -M vicmd '\e\e' sudo-command-line
  bindkey -M viins '\e\e' sudo-command-line
}

dotfiles_zsh_enable_command_not_found() {
  local handler

  for handler in \
    /usr/share/doc/pkgfile/command-not-found.zsh \
    /usr/share/zsh/plugins/xbps-command-not-found/xbps-command-not-found.zsh \
    /opt/homebrew/Library/Homebrew/command-not-found/handler.sh \
    /usr/local/Homebrew/Library/Homebrew/command-not-found/handler.sh \
    /home/linuxbrew/.linuxbrew/Homebrew/Library/Homebrew/command-not-found/handler.sh \
    /opt/homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh \
    /usr/local/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh \
    /home/linuxbrew/.linuxbrew/Homebrew/Library/Taps/homebrew/homebrew-command-not-found/handler.sh
  do
    if [[ -r "$handler" ]]; then
      source "$handler"
      return 0
    fi
  done

  if [[ -x /usr/lib/command-not-found || -x /usr/share/command-not-found/command-not-found ]]; then
    command_not_found_handler() {
      if [[ -x /usr/lib/command-not-found ]]; then
        /usr/lib/command-not-found -- "$1"
      elif [[ -x /usr/share/command-not-found/command-not-found ]]; then
        /usr/share/command-not-found/command-not-found -- "$1"
      else
        printf "zsh: command not found: %s\n" "$1" >&2
        return 127
      fi
    }
    return 0
  fi

  if [[ -x /usr/libexec/pk-command-not-found ]]; then
    command_not_found_handler() {
      if [[ -S /var/run/dbus/system_bus_socket && -x /usr/libexec/packagekitd ]]; then
        /usr/libexec/pk-command-not-found "$@"
      else
        printf "zsh: command not found: %s\n" "$1" >&2
        return 127
      fi
    }
    return 0
  fi

  if [[ -x /run/current-system/sw/bin/command-not-found ]]; then
    command_not_found_handler() {
      /run/current-system/sw/bin/command-not-found "$@"
    }
    return 0
  fi

  if [[ -x /data/data/com.termux/files/usr/libexec/termux/command-not-found ]]; then
    command_not_found_handler() {
      /data/data/com.termux/files/usr/libexec/termux/command-not-found "$1"
    }
    return 0
  fi

  if [[ -x /usr/bin/command-not-found ]]; then
    command_not_found_handler() {
      /usr/bin/command-not-found "$1"
    }
  fi
}

kubectx_prompt_info() {
  (( $+commands[kubectl] )) || return

  local current_ctx
  current_ctx=$(kubectl config current-context 2> /dev/null)
  [[ -n "$current_ctx" ]] || return

  echo "${current_ctx:gs/%/%%}"
}

dotfiles_zsh_enable_kubectl() {
  (( $+commands[kubectl] )) || return 0

  if [[ ! -f "$DOTFILES_ZSH_COMPLETIONS_DIR/_kubectl" ]]; then
    typeset -g -A _comps
    autoload -Uz _kubectl
    _comps[kubectl]=_kubectl
  fi

  if [[ -t 1 ]]; then
    kubectl completion zsh 2> /dev/null >| "$DOTFILES_ZSH_COMPLETIONS_DIR/_kubectl" &|
  else
    kubectl completion zsh 2> /dev/null >| "$DOTFILES_ZSH_COMPLETIONS_DIR/_kubectl" || true
  fi
  alias k='kubectl'
}

dotfiles_zsh_load_plugins() {
  dotfiles_zsh_source_if_exists "$DOTFILES_ZSH_PLUGIN_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
  dotfiles_zsh_source_if_exists "$DOTFILES_ZSH_PLUGIN_DIR/fzf-tab/fzf-tab.plugin.zsh"

  dotfiles_zsh_enable_sudo_shortcut
  dotfiles_zsh_enable_command_not_found
  dotfiles_zsh_enable_kubectl

  dotfiles_zsh_source_if_exists "$DOTFILES_ZSH_PLUGIN_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
}
