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

source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zsh.sh"
dotfiles_zsh_prepare_plugins

# Completions
autoload -Uz compinit && compinit -d "$DOTFILES_ZSH_CACHE_DIR/zcompdump"

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
[[ -d "${HISTFILE%/*}" ]] || mkdir -p "${HISTFILE%/*}" 2>/dev/null
SAVEHIST=$HISTSIZE
setopt appendhistory sharehistory
setopt hist_ignore_space hist_ignore_all_dups hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/common.sh"
dotfiles_zsh_load_plugins
