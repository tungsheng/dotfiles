# shellcheck shell=bash
# Shared helper functions for the dot installer.
# shellcheck disable=SC2034

run() {
    if "$DRY_RUN"; then
        log_dim "[dry-run] $*"
    else
        "$VERBOSE" && log_dim "\$ $*"
        "$@"
    fi
}

has_cmd()  { command -v "$1" >/dev/null 2>&1; }
has_path() { [ -e "$1" ]; }

is_managed_path_linked() {
    local path="$1"

    while [ "$path" != "$HOME" ] && [ "$path" != "/" ]; do
        [ -L "$path" ] && return 0
        path=$(dirname "$path")
    done

    return 1
}

parse_dep_entry() {
    local item="$1"
    IFS='|' read -r DEP_CMD DEP_BREW DEP_DNF DEP_APT <<< "$item"
    DEP_CMD="${DEP_CMD// /}"
    DEP_BREW="${DEP_BREW// /}"
    DEP_DNF="${DEP_DNF// /}"
    DEP_APT="${DEP_APT// /}"
}

dep_pkg_for_os() {
    case "$1" in
        macos)  echo "$DEP_BREW" ;;
        fedora) echo "$DEP_DNF" ;;
        debian) echo "$DEP_APT" ;;
        *)      echo "" ;;
    esac
}

parse_path_entry() {
    ENTRY_PATH="${1%%|*}"
    ENTRY_NAME="${1##*|}"
}

parse_extra_entry() {
    local item="$1"
    EXTRA_PATH="${item%%|*}"; item="${item#*|}"
    EXTRA_URL="${item%%|*}"; item="${item#*|}"
    EXTRA_TYPE="${item%%|*}"; item="${item#*|}"
    EXTRA_NAME="${item%%|*}"
    if [ "$item" = "$EXTRA_NAME" ]; then
        EXTRA_REF=""
    else
        EXTRA_REF="${item#*|}"
    fi
}

git_extra_at_ref() {
    [ -n "$EXTRA_REF" ] || return 1
    [ "$EXTRA_REF" != "-" ] || return 1
    [ -d "$EXTRA_PATH/.git" ] || return 1
    [ "$(git -C "$EXTRA_PATH" rev-parse HEAD 2>/dev/null)" = "$EXTRA_REF" ]
}

count_child_dirs() {
    [ -d "$1" ] || { echo ""; return; }
    find "$1" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' '
}

run_nvim_headless_task() {
    local command="$1" label="$2"
    if "$DRY_RUN"; then
        log_dim "[dry-run] nvim --headless \"$command\" +qa"
        return 0
    fi
    run_with_spin "$label" nvim --headless "$command" +qa
}

list_mason_packages() {
    [ -f "$MASON_PKG_FILE" ] || return 0
    grep -Ev '^[[:space:]]*(#|$)' "$MASON_PKG_FILE"
}

count_mason_packages() {
    list_mason_packages | wc -l | tr -d ' '
}

count_installed_mason_packages() {
    local count=0 pkg
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue
        [ -d "$XDG_DATA_HOME/nvim/mason/packages/$pkg" ] && count=$((count + 1))
    done < <(list_mason_packages)
    echo "$count"
}

missing_mason_packages() {
    local pkg
    while IFS= read -r pkg; do
        [ -z "$pkg" ] && continue
        [ -d "$XDG_DATA_HOME/nvim/mason/packages/$pkg" ] || echo "$pkg"
    done < <(list_mason_packages)
}

build_mason_install_command() {
    local packages=()
    local pkg

    while IFS= read -r pkg; do
        [ -n "$pkg" ] && packages+=("$pkg")
    done < <(list_mason_packages)

    [ ${#packages[@]} -gt 0 ] || return 1

    printf "+MasonInstall"
    for pkg in "${packages[@]}"; do
        printf " %s" "$pkg"
    done
}

join_by_comma() {
    local first=true item
    for item in "$@"; do
        [ -n "$item" ] || continue
        if "$first"; then
            first=false
        else
            printf ", "
        fi
        printf "%s" "$item"
    done
}

detect_os() {
    case "$OSTYPE" in darwin*) echo "macos"; return ;; esac
    has_cmd dnf && echo "fedora" && return
    has_cmd apt && echo "debian" && return
    echo "unknown"
}

get_packages() {
    local os="$1" pkg result=""
    for item in "${DEPS[@]}"; do
        parse_dep_entry "$item"
        pkg=$(dep_pkg_for_os "$os")
        [ -n "$pkg" ] && [ "$pkg" != "-" ] && result="$result$pkg "
    done
    echo "${result% }"  # trim trailing space
}

get_cmd_version() {
    local cmd="$1"
    case "$cmd" in
        nvim)    "$cmd" --version 2>/dev/null | head -1 | sed 's/NVIM v//' ;;
        tmux)    "$cmd" -V 2>/dev/null | cut -d' ' -f2 ;;
        zoxide)  "$cmd" --version 2>/dev/null | cut -d' ' -f2 ;;
        fzf)     "$cmd" --version 2>/dev/null | cut -d' ' -f1 ;;
        fd)      "$cmd" --version 2>/dev/null | cut -d' ' -f2 ;;
        rg)      "$cmd" --version 2>/dev/null | head -1 | cut -d' ' -f2 ;;
        stow)    "$cmd" --version 2>/dev/null | head -1 | awk '{print $NF}' ;;
        uv)      "$cmd" --version 2>/dev/null | cut -d' ' -f2 ;;
        *)       echo "" ;;
    esac
}
