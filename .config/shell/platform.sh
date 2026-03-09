# shellcheck shell=bash
# Shared platform-specific shell helpers.

dotfiles_source_homebrew_shellenv() {
  case "${OSTYPE:-}" in
    darwin*)
      if [[ -x /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      elif [[ -x /usr/local/bin/brew ]]; then
        eval "$(/usr/local/bin/brew shellenv)"
      fi
      ;;
  esac
}
