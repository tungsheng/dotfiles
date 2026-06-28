# Powerlevel10k instant prompt (keep at top)
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Platform bootstrap
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/platform.sh"
dotfiles_source_homebrew_shellenv

source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/zsh.sh"
dotfiles_zsh_prepare_plugins

# Completions
autoload -Uz compinit && compinit -d "$DOTFILES_ZSH_CACHE_DIR/zcompdump"

# Powerlevel10k config
if (( $+functions[p10k] )) && [[ -f ~/.p10k.zsh ]]; then
  source ~/.p10k.zsh
fi

# Editing mode
bindkey -e

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
dotfiles_zsh_bind_history_keys

# zoxide must be last so nothing replaces `cd`. Do not gate on `[ -t 0 ]` — tmux
# and some hosts report a non-TTY stdin during startup and would skip init.
if command -v zoxide >/dev/null; then
  # zoxide's doctor diagnostic targets humans configuring an interactive shell.
  # In non-interactive shells (scripts, CI) its chpwd hook isn't registered the
  # way it expects, so it prints a false-positive warning to stderr on every `cd`.
  # Agent sandboxes run an *interactive* zsh with stdout piped, so also silence it
  # when stdout isn't a TTY. Gate on stdout (not stdin) to avoid the tmux-startup
  # non-TTY-stdin issue. Keep the diagnostic for real interactive terminals.
  { [[ -o interactive ]] && [[ -t 1 ]]; } || export _ZO_DOCTOR=0
  eval "$(zoxide init --cmd cd zsh)"
  alias z=__zoxide_z
fi
