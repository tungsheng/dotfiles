# CLAUDE.md

Context for Claude Code when working with this repository.

## Overview

Dotfiles repository using GNU Stow for symlink management. Supports macOS, Debian/Ubuntu, and RHEL/Fedora/Alma.

## Commands

```shell
./setup              # Install (auto-detects OS)
./setup uninstall    # Remove symlinks
./setup health       # Check status
./setup --dry-run    # Preview changes
./setup --verbose    # Detailed output
```

## Architecture

```
dotfiles/
├── setup                    # Install script (all config at top)
├── .stow-local-ignore       # Excluded from symlinks
├── .zshrc / .bashrc         # Shell configs
└── .config/
    ├── nvim/                # Neovim (NvChad + Lazy.nvim)
    ├── tmux/                # Tmux (TPM plugins)
    ├── alacritty/           # Terminal (Tokyo Night theme)
    └── shell/aliases.sh     # Shared aliases
```

## Key Patterns

**Dependencies** defined in `setup` as `cmd|brew|dnf|apt`:
```bash
DEPS=(
    "nvim|neovim|neovim|neovim"  # cmd differs from package
    "fd|fd|fd-find|fd-find"      # Package name differs by OS
    "zoxide|zoxide|-|zoxide"     # Use - if unavailable
    "-||-git|git"                # Use - to skip health check
)
```

**Managed files** tracked for backup/health:
```bash
MANAGED_FILES=(.zshrc .bashrc .config/nvim ...)
```

**Stow ignores** in `.stow-local-ignore` (regex patterns)

## Tools

| Tool | Config | Plugin Manager |
|------|--------|----------------|
| Zsh | `.zshrc` | Zinit |
| Neovim | `.config/nvim/` | Lazy.nvim |
| Tmux | `.config/tmux/` | TPM |

## Conventions

- Shared aliases: `.config/shell/aliases.sh`
- Neovim customizations: `lua/plugins/init.lua`, `lua/mappings.lua`
- Tmux prefix: `Ctrl+Space`
- Cross-tool navigation: `Ctrl+h/j/k/l` (vim-tmux-navigator)
