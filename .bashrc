#
# ~/.bashrc
#

# If not running interactively, don't do anything
# [[ $- != *i* ]] && return

# Set to superior editing mode
set -o vi

export BASH_SILENCE_DEPRECATION_WARNING=1
source ~/.git-prompt.sh

# ======== PROMPT =========
export PS1='\[\e[33m\]\u\[\e[0m\]@\[\e[34m\]\h\[\e[0m\]:\[\e[35m\]\W\[\e[0m\] $(__git_ps1 "(%s)") \n$ '

# ======== ALIASES =========
alias v=nvim

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

alias ls='ls --color=auto'
alias ll='ls -la'
alias la='ls -lathr'

alias ga="git add"
alias gc="git co"
alias gcm="git commit -m"
alias gl="git pull"
alias gp="git push"
alias gd="git diff"
alias gss="git stash save"
alias gsp="git stash pop"
alias gmv="git mv"
alias grm="git rm"
alias grn="git-rename"
alias gundo="git reset --soft HEAD~1"

# ======== FUNCTIONS =========
function g() {
	if [[ $# > 0 ]]; then
		# if there are arguments, send them to git
		git $@
	else
		# otherwise, run git status
		git status
	fi
}
