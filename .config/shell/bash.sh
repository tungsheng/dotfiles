# shellcheck shell=bash
# Bash-specific interactive shell setup.

# History
HISTSIZE=5000
HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/bash/history"
HISTFILESIZE=$HISTSIZE
HISTCONTROL=ignoreboth:erasedups
[[ -d "${HISTFILE%/*}" ]] || mkdir -p "${HISTFILE%/*}" 2>/dev/null
shopt -s histappend cmdhist

dotfiles_bash_sync_history() {
  builtin history -a
  builtin history -n
}

case ";${PROMPT_COMMAND:-};" in
  *";dotfiles_bash_sync_history;"*) ;;
  ";;") PROMPT_COMMAND="dotfiles_bash_sync_history" ;;
  *) PROMPT_COMMAND="dotfiles_bash_sync_history;${PROMPT_COMMAND}" ;;
esac

# Git prompt
for git_prompt_path in \
  /opt/homebrew/etc/bash_completion.d/git-prompt.sh \
  /usr/local/etc/bash_completion.d/git-prompt.sh \
  /usr/share/git/completion/git-prompt.sh \
  /usr/share/git-core/contrib/completion/git-prompt.sh \
  /usr/lib/git-core/git-sh-prompt
do
  if [[ -f "$git_prompt_path" ]]; then
    # shellcheck disable=SC1090
    source "$git_prompt_path"
    break
  fi
done

if declare -F __git_ps1 >/dev/null; then
  PS1='\[\e[33m\]\u\[\e[0m\]@\[\e[34m\]\h\[\e[0m\]:\[\e[35m\]\W\[\e[0m\]$(__git_ps1 " (%s)") \n$ '
else
  PS1='\[\e[33m\]\u\[\e[0m\]@\[\e[34m\]\h\[\e[0m\]:\[\e[35m\]\W\[\e[0m\] \n$ '
fi
