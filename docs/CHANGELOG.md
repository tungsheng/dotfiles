# Changelog

## v1.4.0 (2026-02-16)

### Added
- `./dot update` command — pull latest, re-stow symlinks, update Zinit/Lazy.nvim/TPM plugins
- ShellCheck CI workflow (`.github/workflows/lint.yml`)
- Dependency skip optimization — skips package manager when all deps already installed

### Fixed
- `run_with_spin` now reports failures instead of silently exiting under `set -e`
- Use safe array expansion for package installs (brew/dnf/apt)
- Add `-f` flag to zoxide curl install to fail on HTTP errors

### Removed
- Dead `configs/neogit.lua` (306 lines, never imported)
- Deprecated `configs/null-ls.lua` and `plugins/mason-null-ls.lua` (replaced by conform.nvim)

### Security
- Exclude `gh/hosts.yml` from stow (contains GitHub user identity)
- Add warning comments for `~/.env.secrets` sourcing in `.zshrc` and `.bashrc`

## v1.3.0 (2026-01-25)

- Organize documentation into `docs/` folder
- Improve docs consistency (keybinding notation, post-install steps)
- Add dates to changelog entries
- Update post-install messages in `dot` script

## v1.2.0 (2026-01-23)

- Add `uv` Python package manager to dependencies
- Add shared NVM script with XDG support
- Use XDG-compliant paths for state files
- Rename CONTRIBUTING.md to DEVELOPER_GUIDE.md
- Add screenshots to README
- Refactor shell configs to reduce duplication
- Update nvim packages and keybinding docs

## v1.1.0 (2026-01-23)

- Add health check: font detection, plugin counts (Zinit, Lazy.nvim, TPM)
- Add expanded shell aliases
- Add conform.nvim and additional LSP configs
- Fix NVM path detection for Mason compatibility
- Fix bash compatibility issues

## v1.0.0 (2026-01-23)

- Initial release with GNU Stow
- Add `dot` CLI: install, uninstall, health, status commands
- Support macOS, Debian/Ubuntu, Fedora/RHEL/Alma
- Support bash 3.2+ (macOS default)
- Add dry-run mode (`-n`) and verbose mode (`-v`)
- Auto-backup existing dotfiles before install
- Add Neovim config with Lazy.nvim and blink.cmp
- Add Tmux config with TPM
- Add Alacritty config with Tokyo Night theme
- Add Zsh config with Zinit
- Add KEYBINDINGS.md and CLAUDE.md docs
