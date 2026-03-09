# shellcheck shell=bash
# Top-level dot command implementations.

cmd_health() {
    print_banner
    echo -e " ${BOLD}Health Check${NC}"
    local ok=0 fail=0 warn=0
    local os
    os=$(detect_os)

    echo
    echo -e " ${DIM}Shell: $SHELL${NC}"
    echo -e " ${DIM}OS: $os${NC}"

    log_step 1 "$HEALTH_STEPS" "Symlinks"
    local file
    for file in "${MANAGED_FILES[@]}"; do
        if [ -e "$HOME/$file" ] && is_managed_path_linked "$HOME/$file"; then
            log_ok "$file"
            ok=$((ok + 1))
        elif [ -e "$HOME/$file" ]; then
            log_warn "$file ${DIM}(exists but not symlinked)${NC}"
            warn=$((warn + 1))
        else
            log_fail "$file"
            fail=$((fail + 1))
        fi
    done

    log_step 2 "$HEALTH_STEPS" "Dependencies"
    local item
    for item in "${DEPS[@]}"; do
        local cmd pkg hint
        parse_dep_entry "$item"
        cmd="$DEP_CMD"
        pkg=$(dep_pkg_for_os "$os")

        [ "$cmd" = "-" ] || [ -z "$cmd" ] && continue

        if has_cmd "$cmd"; then
            local ver
            ver=$(get_cmd_version "$cmd")
            if [ -n "$ver" ]; then
                log_ok "$cmd ${DIM}$ver${NC}"
            else
                log_ok "$cmd"
            fi
            ok=$((ok + 1))
        else
            hint=""
            case "$os" in
                macos)  [ "$pkg" != "-" ] && [ -n "$pkg" ] && hint="brew install $pkg" ;;
                fedora) [ "$pkg" != "-" ] && [ -n "$pkg" ] && hint="sudo dnf install $pkg" ;;
                debian) [ "$pkg" != "-" ] && [ -n "$pkg" ] && hint="sudo apt install $pkg" ;;
            esac
            if [ -n "$hint" ]; then
                log_fail "$cmd ${DIM}(run: $hint)${NC}"
            else
                log_fail "$cmd ${DIM}(not available for $os)${NC}"
            fi
            fail=$((fail + 1))
        fi
    done

    log_step 3 "$HEALTH_STEPS" "Neovim tools"
    if has_cmd nvim; then
        local total installed
        total=$(count_mason_packages)
        installed=$(count_installed_mason_packages)

        if [ "$total" -eq 0 ]; then
            log_warn "No Mason packages configured"
            warn=$((warn + 1))
        elif [ "$installed" -eq "$total" ]; then
            log_ok "Mason packages ${DIM}($installed/$total installed)${NC}"
            ok=$((ok + 1))
        else
            local install_cmd
            install_cmd=$(build_mason_install_command)
            local missing=()
            local pkg
            while IFS= read -r pkg; do
                [ -n "$pkg" ] && missing+=("$pkg")
            done < <(missing_mason_packages)

            log_fail "Mason packages ${DIM}($installed/$total installed)${NC}"
            if [ ${#missing[@]} -gt 0 ]; then
                log_dim "Missing: $(join_by_comma "${missing[@]}")"
            fi
            if [ -n "$install_cmd" ]; then
                log_dim "Run: nvim --headless \"$install_cmd\" +qa"
            else
                log_dim "Run: nvim and execute :MasonInstallAll"
            fi
            fail=$((fail + 1))
        fi
    else
        log_warn "Neovim not installed"
        warn=$((warn + 1))
    fi

    log_step 4 "$HEALTH_STEPS" "Fonts"
    local font_dir="$HOME/Library/Fonts"
    local can_check_fonts=false
    has_cmd fc-list && can_check_fonts=true
    [[ -d "$font_dir" ]] && can_check_fonts=true

    if [[ "$can_check_fonts" == "true" ]]; then
        local font
        for font in "JetBrainsMono" "Hurmit"; do
            if has_cmd fc-list; then
                if fc-list 2>/dev/null | grep -qi "${font}.*Nerd"; then
                    log_ok "$font Nerd Font"
                    ok=$((ok + 1))
                else
                    log_warn "$font Nerd Font ${DIM}(not installed)${NC}"
                    warn=$((warn + 1))
                fi
            elif compgen -G "$font_dir/*${font}*" > /dev/null 2>&1; then
                log_ok "$font Nerd Font"
                ok=$((ok + 1))
            else
                log_warn "$font Nerd Font ${DIM}(not installed)${NC}"
                warn=$((warn + 1))
            fi
        done
    else
        log_dim "Cannot verify fonts (no fc-list or font directory)"
    fi

    log_step 5 "$HEALTH_STEPS" "Plugins"
    local plugins=(
        "$XDG_DATA_HOME/zsh/plugins|zsh plugins"
        "$XDG_DATA_HOME/nvim/lazy|lazy.nvim"
        "$HOME/.config/tmux/plugins/tpm|tpm"
    )
    for item in "${plugins[@]}"; do
        parse_path_entry "$item"
        if has_path "$ENTRY_PATH"; then
            local count="" count_dir="$ENTRY_PATH"
            [ "$ENTRY_NAME" = "tpm" ] && count_dir="$HOME/.config/tmux/plugins"
            count=$(count_child_dirs "$count_dir")
            if [ -n "$count" ] && [ "$count" != "0" ]; then
                log_ok "$ENTRY_NAME ${DIM}($count plugins)${NC}"
            else
                log_ok "$ENTRY_NAME"
            fi
            ok=$((ok + 1))
        else
            log_warn "$ENTRY_NAME ${DIM}(not installed)${NC}"
            warn=$((warn + 1))
        fi
    done

    log_summary "$ok" "$fail" "$warn"
}

cmd_status() {
    local os
    os=$(detect_os)

    echo
    echo -e " ${BOLD}Dotfiles Status${NC}"
    echo -e " ${DIM}───────────────────────────────────────${NC}"

    local symlinks_ok=0 symlinks_total=${#MANAGED_FILES[@]}
    local file
    for file in "${MANAGED_FILES[@]}"; do
        [ -e "$HOME/$file" ] && is_managed_path_linked "$HOME/$file" && symlinks_ok=$((symlinks_ok + 1))
    done
    if [ "$symlinks_ok" -eq "$symlinks_total" ]; then
        echo -e " ${GREEN}Symlinks${NC}     $symlinks_ok/$symlinks_total active"
    else
        echo -e " ${YELLOW}Symlinks${NC}     $symlinks_ok/$symlinks_total active"
    fi

    local shell_name="${SHELL##*/}"
    local shell_info="$shell_name"
    if [ "$shell_name" = "zsh" ] && [ -d "$XDG_DATA_HOME/zsh/plugins" ]; then
        local zsh_plugin_count
        zsh_plugin_count=$(count_child_dirs "$XDG_DATA_HOME/zsh/plugins")
        shell_info="$shell_name ${DIM}($zsh_plugin_count plugins)${NC}"
    fi
    echo -e " ${CYAN}Shell${NC}        $shell_info"

    local lazy_dir="$XDG_DATA_HOME/nvim/lazy"
    if [ -d "$lazy_dir" ]; then
        local nvim_plugins
        nvim_plugins=$(count_child_dirs "$lazy_dir")
        echo -e " ${CYAN}Neovim${NC}       lazy.nvim ${DIM}($nvim_plugins plugins)${NC}"
    else
        echo -e " ${DIM}Neovim${NC}       not configured"
    fi

    local mason_total
    mason_total=$(count_mason_packages)
    if [ "$mason_total" -gt 0 ]; then
        local mason_installed
        mason_installed=$(count_installed_mason_packages)
        if [ "$mason_installed" -eq "$mason_total" ]; then
            echo -e " ${CYAN}Mason${NC}        ${mason_installed}/${mason_total} packages"
        else
            echo -e " ${YELLOW}Mason${NC}        ${mason_installed}/${mason_total} packages"
        fi
    fi

    local tpm_dir="$HOME/.config/tmux/plugins"
    if [ -d "$tpm_dir" ]; then
        local tmux_plugins
        tmux_plugins=$(count_child_dirs "$tpm_dir")
        echo -e " ${CYAN}Tmux${NC}         tpm ${DIM}($tmux_plugins plugins)${NC}"
    else
        echo -e " ${DIM}Tmux${NC}         not configured"
    fi

    echo -e " ${CYAN}OS${NC}           $os"

    if [ -f "$STATE_FILE" ]; then
        local last_sync
        last_sync=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$STATE_FILE" 2>/dev/null) || \
            last_sync=$(stat -c "%y" "$STATE_FILE" 2>/dev/null | cut -d'.' -f1)
        echo -e " ${CYAN}Last sync${NC}    $last_sync"
    fi

    echo
    echo -e " ${DIM}Run './dot health' for full check${NC}"
    echo
}

cmd_uninstall() {
    print_banner
    echo -e " ${BOLD}Uninstall${NC}"
    "$DRY_RUN" && echo -e " ${DIM}Dry run - no changes will be made${NC}"

    has_cmd stow || { log_fail "stow not found"; exit 1; }

    log_step 1 "$UNINSTALL_STEPS" "Remove symlinks"
    delete_symlinks
    log_ok "Symlinks removed"

    if "$DRY_RUN"; then
        log_step 2 "$UNINSTALL_STEPS" "Cleanup"
        log_dim "[dry-run] skipped"
        return
    fi

    log_step 2 "$UNINSTALL_STEPS" "Cleanup"
    log_dim "Optional - press y to remove, Enter to skip"
    echo

    local item
    for item in "${CLEANUPS[@]}"; do
        parse_path_entry "$item"
        if has_path "$ENTRY_PATH"; then
            printf "     Remove %s? [y/N] " "$ENTRY_NAME"
            read -r REPLY
            case "$REPLY" in
                [Yy]*) rm -rf "$ENTRY_PATH"; log_ok "Removed $ENTRY_NAME" ;;
                *)     log_dim "Kept $ENTRY_NAME" ;;
            esac
        fi
    done
    rm -rf "$XDG_STATE_HOME/nvim" "${XDG_CACHE_HOME:-$HOME/.cache}/nvim" 2>/dev/null || true

    echo
    log_ok "Uninstall complete"
    log_dim "System packages were not removed"
}

cmd_install() {
    print_banner
    local os
    os=$(detect_os)

    echo -e " ${BOLD}Install${NC}"
    echo -e " ${DIM}OS: $os${NC}"
    "$DRY_RUN" && echo -e " ${DIM}Dry run - no changes will be made${NC}"

    log_step 1 "$INSTALL_STEPS" "Backup"
    backup_managed_files

    log_step 2 "$INSTALL_STEPS" "Dependencies"
    install_deps "$os"

    log_step 3 "$INSTALL_STEPS" "Shell"
    choose_shell

    log_step 4 "$INSTALL_STEPS" "Extras"
    sync_extras

    log_step 5 "$INSTALL_STEPS" "Symlinks"
    restow_symlinks
    if "$DRY_RUN"; then
        log_ok "Symlinks ready"
    else
        log_ok "Symlinks created"
    fi

    log_step 6 "$INSTALL_STEPS" "Neovim"
    bootstrap_neovim

    write_install_state "$os"

    echo
    print_install_summary

    echo
    echo -e " ${GREEN}${BOLD}Done!${NC}"
    echo
    print_next_steps
    echo
    log_dim "Verify: ./dot health"
    echo
}

cmd_update() {
    print_banner
    echo -e " ${BOLD}Update${NC}"
    "$DRY_RUN" && echo -e " ${DIM}Dry run - no changes will be made${NC}"

    log_step 1 "$UPDATE_STEPS" "Pull latest"
    if "$DRY_RUN"; then
        log_dim "[dry-run] git pull"
    else
        (
            cd "$DOTFILES_DIR"
            run_with_spin "Pulling latest changes..." git pull --ff-only
        ) || {
            log_fail "Pull failed (merge conflicts?)"
            log_dim "Resolve manually, then re-run ./dot update"
            exit 1
        }
    fi
    log_ok "Dotfiles up to date"

    log_step 2 "$UPDATE_STEPS" "Symlinks"
    restow_symlinks
    log_ok "Symlinks refreshed"

    log_step 3 "$UPDATE_STEPS" "Plugins"
    sync_extras

    if has_cmd nvim; then
        sync_neovim_plugins || true
        sync_mason_packages || true
    fi

    sync_tmux_plugins

    echo
    log_ok "Update complete"
    echo
}
