# shellcheck shell=bash
# Terminal UI helpers for the dot installer.
# shellcheck disable=SC2034

RED='\033[0;31m' GREEN='\033[0;32m' YELLOW='\033[0;33m'
BLUE='\033[0;34m' CYAN='\033[0;36m' DIM='\033[2m' BOLD='\033[1m' NC='\033[0m'

INSTALLED_ITEMS=()
SKIPPED_ITEMS=()

track_installed() { INSTALLED_ITEMS+=("$1"); }
track_skipped()   { SKIPPED_ITEMS+=("$1 ($2)"); }

spin() {
    local pid=$1 msg=$2
    local chars='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    local i=0 len=${#chars}
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r ${BLUE}%s${NC}  %s" "${chars:$i:1}" "$msg"
        i=$(( (i + 1) % len ))
        sleep 0.1
    done
    printf "\r"
}

run_with_spin() {
    local msg="$1"
    shift
    if "$DRY_RUN"; then
        log_dim "[dry-run] $*"
        return 0
    fi
    "$@" >/dev/null 2>&1 &
    local pid=$!
    spin "$pid" "$msg"
    wait "$pid" || { log_fail "$msg"; return 1; }
}

print_banner() {
    echo -e "${BOLD}"
    cat <<'EOF'

        ╺┳┓┏━┓╺┳╸┏━╸╻╻  ┏━╸┏━┓
         ┃┃┃ ┃ ┃ ┣╸ ┃┃  ┣╸ ┗━┓
        ╺┻┛┗━┛ ╹ ╹  ╹┗━╸┗━╸┗━┛
EOF
    echo -e "${NC}${DIM}        v${VERSION}${NC}"
    echo
}

log_ok()   { echo -e " ${GREEN}✓${NC}  $1"; }
log_fail() { echo -e " ${RED}✗${NC}  $1" >&2; }
log_warn() { echo -e " ${YELLOW}!${NC}  $1"; }
log_info() { echo -e " ${BLUE}→${NC}  $1"; }
log_dim()  { echo -e "     ${DIM}$1${NC}"; }

log_step() {
    echo
    echo -e " ${BOLD}[$1/$2]${NC} ${BOLD}$3${NC}"
}

log_summary() {
    local ok="$1" fail="$2" warn="${3:-0}"
    echo
    echo -n " "
    [ "$ok" -gt 0 ] && echo -ne "${GREEN}$ok ok${NC}  "
    [ "$fail" -gt 0 ] && echo -ne "${RED}$fail failed${NC}  "
    [ "$warn" -gt 0 ] && echo -ne "${YELLOW}$warn warnings${NC}"
    echo
}

print_usage() {
    print_banner
    echo -e " ${BOLD}Usage:${NC} ./dot <command> [options]"
    echo
    echo -e " ${BOLD}Commands${NC}"
    echo "   install      Install dotfiles and dependencies"
    echo "   update       Pull latest changes and update plugins"
    echo "   uninstall    Remove symlinks and optionally clean up"
    echo "   health       Check installation status"
    echo "   status       Quick overview of installation state"
    echo
    echo -e " ${BOLD}Options${NC}"
    echo "   -n, --dry-run    Show what would be done"
    echo "   -v, --verbose    Show commands being run"
    echo "   -h, --help       Show this help"
    echo
    echo -e " ${BOLD}Examples${NC}"
    echo "   ./dot install        Install everything"
    echo "   ./dot install -n     Preview install"
    echo "   ./dot status         Quick status"
    echo "   ./dot health         Full health check"
}

print_install_summary() {
    if [ ${#INSTALLED_ITEMS[@]} -gt 0 ] || [ ${#SKIPPED_ITEMS[@]} -gt 0 ]; then
        echo -e " ${BOLD}Summary${NC}"

        if [ ${#INSTALLED_ITEMS[@]} -gt 0 ]; then
            if "$DRY_RUN"; then
                echo -ne " ${GREEN}Ready:${NC} "
            else
                echo -ne " ${GREEN}Installed:${NC} "
            fi
            local first=true
            local item
            for item in "${INSTALLED_ITEMS[@]}"; do
                "$first" || echo -n ", "
                echo -n "$item"
                first=false
            done
            echo
        fi

        if [ ${#SKIPPED_ITEMS[@]} -gt 0 ]; then
            echo -e " ${YELLOW}Skipped:${NC}"
            local item
            for item in "${SKIPPED_ITEMS[@]}"; do
                echo -e "     ${DIM}-${NC} ${DIM}$item${NC}"
            done
        fi
    fi
}

print_next_steps() {
    echo -e " ${BOLD}Next steps${NC}"

    if [ "$USE_SHELL" = "bash" ]; then
        echo -e "   ${CYAN}1.${NC} Restart terminal (or run ${BOLD}bash${NC})"
        echo -e "   ${CYAN}2.${NC} Open ${BOLD}nvim${NC}"
        echo -e "   ${CYAN}3.${NC} If editor tools are missing, run ${BOLD}:MasonInstallAll${NC}"
        echo -e "   ${CYAN}4.${NC} Open ${BOLD}tmux${NC}, press ${BOLD}Ctrl+Space I${NC} for plugins"
        return
    fi

    echo -e "   ${CYAN}1.${NC} Restart terminal (or run ${BOLD}zsh${NC})"
    echo -e "   ${CYAN}2.${NC} Run ${BOLD}p10k configure${NC} for prompt setup"
    echo -e "   ${CYAN}3.${NC} Open ${BOLD}nvim${NC}"
    echo -e "   ${CYAN}4.${NC} If editor tools are missing, run ${BOLD}:MasonInstallAll${NC}"
    echo -e "   ${CYAN}5.${NC} Open ${BOLD}tmux${NC}, press ${BOLD}Ctrl+Space I${NC} for plugins"
}
