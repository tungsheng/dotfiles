# CLAUDE.md

Context for Claude Code when working with this repository.

## Overview

Dotfiles repository using GNU Stow. Supports macOS, Debian/Ubuntu, and RHEL/Fedora/Alma.

## Commands

```shell
./dot                 # Show help
./dot install         # Install dotfiles
./dot uninstall       # Remove symlinks
./dot health          # Check status
./dot install -n      # Preview (dry-run)
./dot install -v      # Verbose output
```

## Structure

```
dotfiles/
├── .zshrc                   # Zsh config
├── .bashrc                  # Bash config
├── .config/
│   ├── nvim/                # Neovim (NvChad + Lazy.nvim)
│   ├── tmux/                # Tmux (TPM)
│   ├── alacritty/           # Terminal (Tokyo Night)
│   ├── gh/                  # GitHub CLI
│   └── shell/aliases.sh     # Shared aliases
├── dot                      # Install script (bash 3.2+)
└── .stow-local-ignore       # Stow exclusions
```

## Script Patterns

**Dependencies** - `cmd|brew|dnf|apt`:
```bash
DEPS=(
    "nvim|neovim|neovim|neovim"  # cmd differs from package
    "fd|fd|fd-find|fd-find"      # package name varies by OS
    "zoxide|zoxide|-|zoxide"     # use - if unavailable
    "-||-git|git"                # use - to skip health check
)
```

**Managed files** - tracked for backup/health:
```bash
MANAGED_FILES=(.zshrc .bashrc .config/nvim ...)
```

**Stow ignores** - regex patterns in `.stow-local-ignore`

## Tools

| Tool | Config | Plugin Manager |
|------|--------|----------------|
| Zsh | `.zshrc` | Zinit |
| Neovim | `.config/nvim/` | Lazy.nvim |
| Tmux | `.config/tmux/` | TPM |

## Conventions

- Shared aliases: `.config/shell/aliases.sh`
- Neovim plugins: `lua/plugins/init.lua`
- Neovim keybindings: `lua/mappings.lua`
- Tmux prefix: `Ctrl+Space`
- Cross-tool navigation: `Ctrl+h/j/k/l`
