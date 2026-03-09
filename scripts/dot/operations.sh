# shellcheck shell=bash
# Operational workflows shared by dot commands.

backup_managed_files() {
    local backed_up=0 backup_dir="" file

    if "$DRY_RUN"; then
        log_dim "[dry-run] skipped"
        return 0
    fi

    for file in "${MANAGED_FILES[@]}"; do
        if [ -e "$HOME/$file" ] && ! is_managed_path_linked "$HOME/$file"; then
            if [ -z "$backup_dir" ]; then
                backup_dir="$STATE_DIR/backups/$(date +%Y%m%d-%H%M%S)"
                mkdir -p "$backup_dir"
                log_dim "Location: $backup_dir"
            fi
            # Preserve symlinks inside managed directories; `cp -r` follows them on macOS.
            cp -RP "$HOME/$file" "$backup_dir/"
            log_ok "$file"
            backed_up=$((backed_up + 1))
        fi
    done

    [ "$backed_up" -eq 0 ] && log_ok "Nothing to backup"
}

restow_symlinks() {
    if "$DRY_RUN"; then
        log_dim "[dry-run] stow --target=\$HOME --restow ."
        return 0
    fi

    (
        cd "$DOTFILES_DIR" || exit 1
        stow --target="$HOME" --restow .
    )
}

delete_symlinks() {
    if "$DRY_RUN"; then
        log_dim "[dry-run] stow --target=\$HOME --delete ."
        return 0
    fi

    (
        cd "$DOTFILES_DIR" || exit 1
        stow --target="$HOME" --delete .
    )
}

write_install_state() {
    local os="$1"

    "$DRY_RUN" && return 0

    mkdir -p "$STATE_DIR"
    {
        echo "installed=$(date +%Y-%m-%d\ %H:%M:%S)"
        echo "os=$os"
        echo "shell=$USE_SHELL"
    } > "$STATE_FILE"
}

show_skipped_deps() {
    local os="$1" pkg
    for item in "${DEPS[@]}"; do
        parse_dep_entry "$item"
        pkg=$(dep_pkg_for_os "$os")

        [ "$DEP_CMD" = "-" ] && continue
        [ -n "$pkg" ] && [ "$pkg" != "-" ] && continue

        track_skipped "$DEP_CMD" "not available for $os"
    done
}

all_deps_installed() {
    local item
    for item in "${DEPS[@]}"; do
        parse_dep_entry "$item"
        [ "$DEP_CMD" = "-" ] || [ -z "$DEP_CMD" ] && continue
        has_cmd "$DEP_CMD" || return 1
    done
    return 0
}

sync_neovim_plugins() {
    log_info "Syncing Neovim plugins"
    if ! run_nvim_headless_task "+Lazy! sync" "Syncing Neovim plugins..."; then
        log_warn "Neovim plugin sync failed"
        log_dim "Run: nvim --headless \"+Lazy! sync\" +qa"
        return 1
    fi
    log_ok "Neovim plugins synced"
}

sync_mason_packages() {
    local total command
    total=$(count_mason_packages)
    [ "$total" -eq 0 ] && return 0
    command=$(build_mason_install_command) || return 0

    log_info "Syncing Mason packages"
    if ! run_nvim_headless_task "$command" "Syncing Mason packages..."; then
        log_warn "Mason package sync failed"
        log_dim "Run: nvim --headless \"$command\" +qa"
        return 1
    fi
    log_ok "Mason packages synced ${DIM}($total configured)${NC}"
}

bootstrap_neovim() {
    if ! has_cmd nvim && ! "$DRY_RUN"; then
        log_warn "Neovim bootstrap skipped"
        log_dim "Install neovim first to bootstrap plugins and Mason packages"
        return
    fi

    if sync_neovim_plugins; then
        track_installed "Neovim plugins"
    else
        return
    fi

    if sync_mason_packages; then
        [ "$(count_mason_packages)" -gt 0 ] && track_installed "Mason packages"
    fi
}

install_deps() {
    local os="$1"

    show_skipped_deps "$os"

    if all_deps_installed; then
        log_ok "All dependencies already installed"
        return
    fi

    case "$os" in
        macos)
            local brew_ready=true
            if ! has_cmd brew; then
                log_warn "Homebrew not installed"
                if "$DRY_RUN"; then
                    log_dim "[dry-run] install Homebrew manually from https://brew.sh"
                else
                    log_dim "Install Homebrew manually from https://brew.sh, then re-run ./dot install"
                fi
                track_skipped "Homebrew" "install manually from brew.sh"
                track_skipped "system packages" "install manually via Homebrew"
                track_skipped "fonts" "install manually via Homebrew casks"
                brew_ready=false
            fi

            if "$brew_ready"; then
                log_ok "Homebrew ready"

                local pkgs
                pkgs=$(get_packages "$os")
                if [ -n "$pkgs" ]; then
                    # shellcheck disable=SC2086 # intentional word splitting for package list
                    if "$DRY_RUN"; then
                        log_dim "[dry-run] brew install $pkgs"
                    else
                        read -ra pkg_array <<< "$pkgs"
                        run_with_spin "Installing packages..." brew install --quiet "${pkg_array[@]}"
                    fi
                    log_ok "Packages installed"
                    track_installed "system packages"
                fi

                if "$DRY_RUN"; then
                    log_dim "[dry-run] brew install --cask ${CASKS[*]}"
                else
                    run_with_spin "Installing fonts..." brew install --quiet --cask "${CASKS[@]}"
                fi
                log_ok "Fonts installed"
                track_installed "fonts"
            fi
            ;;

        fedora)
            log_info "Adding EPEL..."
            if "$DRY_RUN"; then
                log_dim "[dry-run] sudo dnf install -y epel-release"
            else
                sudo dnf install -y epel-release 2>/dev/null || true
            fi
            log_ok "EPEL ready"

            local pkgs
            pkgs=$(get_packages "$os")
            if [ -n "$pkgs" ]; then
                if "$DRY_RUN"; then
                    log_dim "[dry-run] sudo dnf install -y $pkgs"
                else
                    read -ra pkg_array <<< "$pkgs"
                    run_with_spin "Installing packages..." sudo dnf install -y "${pkg_array[@]}"
                fi
                log_ok "Packages installed"
                track_installed "system packages"
            fi

            if ! has_cmd zoxide; then
                log_warn "zoxide is not installed"
                if "$DRY_RUN"; then
                    log_dim "[dry-run] install zoxide manually (package unavailable in dnf)"
                else
                    log_dim "Install zoxide manually (package unavailable in dnf), then re-run ./dot health"
                fi
            fi
            ;;

        debian)
            log_info "Updating apt..."
            if "$DRY_RUN"; then
                log_dim "[dry-run] sudo apt update"
            else
                run_with_spin "Updating package lists..." sudo apt update
            fi
            log_ok "Package lists updated"

            local pkgs
            pkgs=$(get_packages "$os")
            if [ -n "$pkgs" ]; then
                if "$DRY_RUN"; then
                    log_dim "[dry-run] sudo apt install -y $pkgs"
                else
                    read -ra pkg_array <<< "$pkgs"
                    run_with_spin "Installing packages..." sudo apt install -y "${pkg_array[@]}"
                fi
                log_ok "Packages installed"
                track_installed "system packages"
            fi
            ;;

        *)
            log_warn "Unknown OS"
            log_dim "Install manually: stow neovim fd ripgrep fzf zoxide tmux git curl zsh"
            has_cmd stow || { log_fail "stow required"; exit 1; }
            ;;
    esac
}

sync_extras() {
    local item
    for item in "${EXTRAS[@]}"; do
        parse_extra_entry "$item"
        local changed=false

        case "$EXTRA_TYPE" in
            curl)
                if has_path "$EXTRA_PATH"; then
                    log_ok "$EXTRA_NAME ready"
                    continue
                fi

                log_info "Downloading $EXTRA_NAME"
                run mkdir -p "$(dirname "$EXTRA_PATH")"
                run curl -fsSL -o "$EXTRA_PATH" "$EXTRA_URL"
                changed=true
                ;;

            git)
                if [ -d "$EXTRA_PATH/.git" ] && git_extra_at_ref; then
                    log_ok "$EXTRA_NAME ready"
                    continue
                fi

                if has_path "$EXTRA_PATH" && [ ! -d "$EXTRA_PATH/.git" ]; then
                    log_warn "$EXTRA_NAME exists but is not a git repository"
                    continue
                fi

                run mkdir -p "$(dirname "$EXTRA_PATH")"
                if [ -d "$EXTRA_PATH/.git" ]; then
                    log_info "Syncing $EXTRA_NAME"
                    if "$DRY_RUN"; then
                        log_dim "[dry-run] git -C $EXTRA_PATH fetch --quiet origin"
                        log_dim "[dry-run] git -C $EXTRA_PATH checkout --quiet $EXTRA_REF"
                    else
                        run git -C "$EXTRA_PATH" fetch --quiet origin
                        run git -C "$EXTRA_PATH" checkout --quiet "$EXTRA_REF"
                    fi
                else
                    log_info "Cloning $EXTRA_NAME"
                    run git clone -q "$EXTRA_URL" "$EXTRA_PATH"
                    [ -n "$EXTRA_REF" ] && [ "$EXTRA_REF" != "-" ] && run git -C "$EXTRA_PATH" checkout --quiet "$EXTRA_REF"
                fi
                changed=true
                ;;
        esac

        if "$DRY_RUN"; then
            log_ok "$EXTRA_NAME ready"
        elif "$changed"; then
            log_ok "$EXTRA_NAME synced"
            track_installed "$EXTRA_NAME"
        fi
    done
}

choose_shell() {
    if has_cmd zsh; then
        USE_SHELL="zsh"
        set_shell
        return
    fi

    log_warn "zsh not found"
    echo
    printf "     Use bash instead? [Y/n] "
    read -r REPLY
    case "$REPLY" in
        [Nn]*)
            log_fail "Aborted"
            log_dim "Install zsh first, then re-run ./dot install"
            exit 1
            ;;
        *)
            USE_SHELL="bash"
            set_shell
            ;;
    esac
}

set_shell() {
    local shell_path current_shell

    if [ "$USE_SHELL" = "bash" ]; then
        shell_path=$(command -v bash)
        current_shell="bash"
    else
        shell_path=$(command -v zsh)
        current_shell="zsh"
    fi

    case "$SHELL" in
        */"$current_shell")
            log_ok "$USE_SHELL (already default)"
            return
            ;;
    esac

    if "$DRY_RUN"; then
        log_dim "[dry-run] chsh -s $shell_path"
        log_ok "$USE_SHELL"
        return
    fi

    if ! grep -q "^${shell_path}$" /etc/shells 2>/dev/null; then
        log_info "Adding to /etc/shells"
        echo "$shell_path" | sudo tee -a /etc/shells >/dev/null
    fi

    log_info "Setting default shell"
    if chsh -s "$shell_path"; then
        log_ok "$USE_SHELL"
        log_dim "Restart terminal to use"
    else
        log_warn "Could not set shell"
        log_dim "Run: chsh -s $shell_path"
    fi
}

sync_tmux_plugins() {
    local tpm_update="$HOME/.config/tmux/plugins/tpm/bin/update_plugins"
    [ -x "$tpm_update" ] || return 0

    log_info "Updating Tmux plugins..."
    if "$DRY_RUN"; then
        log_dim "[dry-run] $tpm_update all"
    else
        run_with_spin "Updating Tmux plugins..." "$tpm_update" all || true
    fi
    log_ok "Tmux plugins updated"
}
