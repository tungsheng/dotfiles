# Dotfiles

Modern terminal development environment with Zsh, Neovim, Tmux, and Alacritty.

## Quick Start

```shell
git clone https://github.com/tungsheng/dotfiles.git ~/dotfiles
cd ~/dotfiles
./dot install
```

The script auto-detects your OS and installs all dependencies.

**Preview first:**
```shell
./dot install -n
```

## Prerequisites

Git is required to clone this repository:

| OS | Command |
|----|---------|
| macOS | `xcode-select --install` |
| Debian/Ubuntu | `sudo apt install git` |
| Fedora/RHEL/Alma | `sudo dnf install git` |

### RHEL/AlmaLinux 9

EPEL repository is required. If install fails:
```shell
sudo dnf install -y epel-release
./dot install
```

## Post-Installation

1. **Restart terminal** (or run `zsh`)
2. Run `p10k configure` to customize prompt
3. Open `nvim` — plugins install automatically
4. Open `tmux`, press `Ctrl+Space I` to install plugins

## Commands

```shell
./dot                 # Show help
./dot install         # Install dotfiles
./dot uninstall       # Remove symlinks
./dot health          # Check status
./dot install -n      # Preview (dry-run)
./dot install -v      # Verbose output
```

## Uninstall

```shell
./dot uninstall
```

Removes symlinks and optionally cleans up plugins/themes. System packages are not removed.

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
├── dot                      # Install script
├── KEYBINDINGS.md           # Key reference
└── CONTRIBUTING.md          # Dev guide
```

## Key Bindings

See [KEYBINDINGS.md](KEYBINDINGS.md) for complete reference.

| Tool | Key | Action |
|------|-----|--------|
| Tmux | `Ctrl+Space` | Prefix |
| Tmux | `Ctrl+h/j/k/l` | Navigate panes |
| Neovim | `Space` | Leader |
| Neovim | `<leader>ff` | Find files |
| Zsh | `Ctrl+r` | History search |

## Manual Installation

<details>
<summary>If you prefer to manage dependencies yourself</summary>

Install stow:

| OS | Command |
|----|---------|
| macOS | `brew install stow` |
| Debian/Ubuntu | `sudo apt install stow` |
| Fedora | `sudo dnf install stow` |
| RHEL/Alma | `sudo dnf install epel-release && sudo dnf install stow` |

Then create symlinks:
```shell
cd ~/dotfiles
stow .
```

</details>

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

[MIT](LICENSE)
