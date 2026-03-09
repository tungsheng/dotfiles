# shellcheck shell=bash
# ~/.bashrc - Bash configuration

# Exit if not interactive
[[ $- != *i* ]] && return

# macOS: silence bash deprecation warning
[[ "$OSTYPE" == darwin* ]] && export BASH_SILENCE_DEPRECATION_WARNING=1

# Emacs mode
set -o emacs

source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/bash.sh"
source "${XDG_CONFIG_HOME:-$HOME/.config}/shell/common.sh"
