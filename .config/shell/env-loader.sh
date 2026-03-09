# shellcheck shell=bash
# Shared loader for ~/.env and ~/.env* files.
# Accepts only KEY=VALUE or export KEY=VALUE lines and exports them literally.

if [ -n "${DOTFILES_ENV_LOADER_LOADED:-}" ]; then
  return 0
fi
DOTFILES_ENV_LOADER_LOADED=1

dotfiles_warn_env() {
  printf 'dotfiles: %s\n' "$1" >&2
}

dotfiles_trim_leading_space() {
  printf '%s' "${1#"${1%%[![:space:]]*}"}"
}

dotfiles_env_file_is_secure() {
  local env_file="$1"
  local perms=""

  [ -f "$env_file" ] || return 1

  if [ -L "$env_file" ]; then
    dotfiles_warn_env "skipping $env_file (symlinks are not allowed)"
    return 1
  fi

  if ! [ -r "$env_file" ]; then
    dotfiles_warn_env "skipping $env_file (not readable)"
    return 1
  fi

  if ! [ -O "$env_file" ]; then
    dotfiles_warn_env "skipping $env_file (not owned by the current user)"
    return 1
  fi

  perms=$(stat -f '%OLp' "$env_file" 2>/dev/null || stat -c '%a' "$env_file" 2>/dev/null || true)
  if [ -n "$perms" ] && (( (8#$perms & 077) != 0 )); then
    dotfiles_warn_env "skipping $env_file (permissions must deny group/other access)"
    return 1
  fi

  return 0
}

load_env_file() {
  local env_file="$1"
  local line trimmed key value
  local line_no=0

  dotfiles_env_file_is_secure "$env_file" || return 0

  while IFS= read -r line || [ -n "$line" ]; do
    line_no=$((line_no + 1))
    trimmed=$(dotfiles_trim_leading_space "$line")

    case "$trimmed" in
      ""|\#*)
        continue
        ;;
      export[[:space:]]*)
        trimmed=${trimmed#export}
        trimmed=$(dotfiles_trim_leading_space "$trimmed")
        ;;
    esac

    case "$trimmed" in
      *=*)
        ;;
      *)
        dotfiles_warn_env "ignoring $env_file:$line_no (expected KEY=VALUE)"
        continue
        ;;
    esac

    key=${trimmed%%=*}
    value=${trimmed#*=}

    case "$key" in
      ""|[0-9]*|*[!A-Za-z0-9_]*)
        dotfiles_warn_env "ignoring $env_file:$line_no (invalid variable name)"
        continue
        ;;
    esac

    case "$value" in
      \"*\")
        value=${value#\"}
        value=${value%\"}
        ;;
      \'*\')
        value=${value#\'}
        value=${value%\'}
        ;;
    esac

    export "$key=$value"
  done < "$env_file"
}

load_home_env_files() {
  local env_home="${1:-$HOME}"
  local env_file

  load_env_file "$env_home/.env"

  while IFS= read -r env_file; do
    [ -n "$env_file" ] || continue
    load_env_file "$env_file"
  done < <(
    find "$env_home" -maxdepth 1 -type f -name '.env*' ! -name '.env' -print 2>/dev/null | LC_ALL=C sort
  )
}
