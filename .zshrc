# Powerlevel10k instant prompt (keep at top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Homebrew
if [[ -f /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -f /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Zinit
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [[ -f "${ZINIT_HOME}/zinit.zsh" ]]; then
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
fi

# Docker completions (before compinit)
[[ -d "$HOME/.docker/completions" ]] && fpath=("$HOME/.docker/completions" $fpath)

# Completions
autoload -Uz compinit && compinit
if [[ -f "${ZINIT_HOME}/zinit.zsh" ]]; then
  zinit cdreplay -q
fi

# Powerlevel10k config
if (( $+functions[p10k] )) && [[ -f ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
fi

# Keybindings (emacs mode)
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward

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

# Safety aliases (interactive shell only)
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'

# Shared config
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/aliases.sh"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/nvm.sh"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/env-loader.sh"

# Shell integrations
command -v fzf >/dev/null && eval "$(fzf --zsh)"
command -v zoxide >/dev/null && eval "$(zoxide init --cmd cd zsh)"

# Bun
export BUN_INSTALL="$HOME/.bun"
[[ -d "$BUN_INSTALL" ]] && export PATH="$BUN_INSTALL/bin:$PATH"

# uv (Python)
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

# Environment files
load_home_env_files "$HOME"
