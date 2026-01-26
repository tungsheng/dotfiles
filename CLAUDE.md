# CLAUDE.md

Context for Claude Code when working with this repository.

## Overview

Dotfiles repository using GNU Stow. Supports macOS, Debian/Ubuntu, and RHEL/Fedora/Alma.

## Commands

```shell
./dot                 # Show help
./dot install         # Install dotfiles
./dot uninstall       # Remove symlinks
./dot health          # Full status check
./dot install -n      # Preview (dry-run)
./dot install -v      # Verbose output
```

## Structure

```
dotfiles/
├── .zshrc                   # Zsh config
├── .bashrc                  # Bash config
├── .config/
│   ├── nvim/                # Neovim (Lazy.nvim)
│   ├── tmux/                # Tmux (TPM)
│   ├── alacritty/           # Terminal (Tokyo Night)
│   ├── gh/                  # GitHub CLI
│   └── shell/aliases.sh     # Shared aliases
├── dot                      # Install script (bash 3.2+)
└── .stow-local-ignore       # Stow exclusions
```

## Script Patterns

**Dependencies** - `cmd | brew | dnf | apt`:
```bash
DEPS=(
    "nvim     | neovim    | neovim    | neovim"     # same package name
    "fd       | fd        | fd-find   | fd-find"    # varies by OS
    "zoxide   | zoxide    | -         | zoxide"     # use - if unavailable
    "-        |           | git       | git"        # use - to skip health check
)
```

**Managed files** - tracked for backup/health:
```bash
MANAGED_FILES=(.zshrc .bashrc .config/nvim ...)
```

**Stow ignores** - regex patterns in `.stow-local-ignore`

## Versioning

- Version from git tags (preferred) or `VERSION` file (fallback)
- Format: `MAJOR.MINOR.PATCH` (semver)
- Tag releases: `git tag -a v1.2.0 -m "v1.2.0 - Description"`
- Update `VERSION` file when tagging
- Changelog in `CHANGELOG.md`

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

## Inspiration

- [Dreams of Code](https://www.youtube.com/watch?v=DzNmUNvnB04)
