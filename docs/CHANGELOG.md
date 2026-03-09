# Changelog

## v1.5.0 (2026-03-09)

### Added
- Safe `~/.env` and `~/.env*` loading for interactive bash and zsh shells
- Modular `scripts/dot/` installer layout split into config, UI, helpers, operations, and commands

### Changed
- Simplify shell startup around shared helpers, XDG paths, and pinned local zsh plugin checkouts
- Clarify repo layout and maintainer docs around shell, platform bootstrap, and installer entrypoints
- Treat machine-local runtime files such as `.zcompdump`, `.nvimlog`, and `.ruff_cache` as ignored local artifacts

### Fixed
- Restore Terraform and HCL filetype detection, `terraformls` startup, and Blink completion behavior for root, block, and `var.*` member contexts
- Use a blocking headless Mason install command in `dot` so Neovim tools bootstrap correctly outside the UI
- Make managed-file health and backup checks handle paths inside symlinked parent directories, including GitHub CLI config
- Replace the GNU-specific NVM version sort fallback with a portable installed-version resolver
- Fix Alacritty config deprecation warnings on older releases
- Use package-provided Git prompt scripts instead of downloaded copies

### Security
- Pin the bootstrap `lazy.nvim` commit instead of cloning a moving branch on first launch
- Remove remote installer script execution for Homebrew and Fedora zoxide setup
- Stop executing env files as shell code and load them as validated key/value data instead
- Stop tracking local GitHub CLI host state in the repo and ignore it by default

## v1.4.3 (2026-02-16)

- Fix CI workflow to only check our scripts (not zshrc/bashrc/third-party)
- Fix useless cat warning (SC2002) in `dot` script

## v1.4.2 (2026-02-16)

- Fix docs: add `./dot update` to README and developer guide
- Fix docs: add `.config/gh/` and `.config/ruff/` to README structure
- Fix docs: expand CLEANUPS example to all 5 entries in developer guide
- Fix docs: correct keybindings for NvChad terminal and Zsh history prefix search
- Fix shellcheck warnings: replace `ls | grep` with glob, fix directive syntax
- Add `shellcheck shell=bash` directive to `aliases.sh` and `nvm.sh`
- Replace `ls -1` with `find -exec basename` in `nvm.sh`

## v1.4.1 (2026-02-16)

- Remove hardcoded `/bin/zsh` from Alacritty (use system default shell)
- Add bash history settings (`HISTSIZE`, `HISTCONTROL=ignoreboth:erasedups`)
- Remove ruff from conform.nvim (ruff LSP already handles formatting)
- Rename ruff config from `pyproject.toml` to `ruff.toml` (proper XDG format)
- Fix `stat` operator precedence in `dot status` command

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
