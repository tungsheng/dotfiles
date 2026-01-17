# Dotfiles

Modern terminal development environment with Zsh, Neovim, Tmux, and Alacritty.

## Prerequisites

**Git** is required to clone this repository:

| OS | Command |
|----|---------|
| macOS | `xcode-select --install` |
| Debian/Ubuntu | `sudo apt install git` |
| Fedora | `sudo dnf install git` |
| AlmaLinux/RHEL 9 | `sudo dnf install git` |

## Installation

```shell
git clone https://github.com/tungsheng/dotfiles.git ~/dotfiles
cd ~/dotfiles
./setup
```

The setup script auto-detects your OS and installs all dependencies.

**Preview changes first:**
```shell
./setup --dry-run
```

### AlmaLinux/RHEL 9 Note

EPEL repository is required for `stow`. If setup fails, run:
```shell
sudo dnf install -y epel-release
./setup
```

## Post-Installation

1. Restart terminal or `source ~/.zshrc`
2. Run `p10k configure` to customize prompt
3. Open `nvim` - plugins install automatically
4. In tmux, press `Ctrl+Space I` to install plugins

## Uninstall

```shell
./setup uninstall
```

Removes symlinks and optionally cleans up plugins/themes. System packages are not removed.

## Manual Installation

If you prefer to manage dependencies yourself:

<details>
<summary>Install stow manually by distro</summary>

| OS | Command |
|----|---------|
| macOS | `brew install stow` |
| Debian/Ubuntu | `sudo apt install stow` |
| Fedora | `sudo dnf install stow` |
| AlmaLinux/RHEL 9 | `sudo dnf install epel-release && sudo dnf install stow` |

</details>

Then create symlinks:
```shell
cd ~/dotfiles
stow .
```

## Structure

```
dotfiles/
├── .config/
│   ├── alacritty/    # Terminal config
│   ├── nvim/         # Neovim (NvChad)
│   ├── tmux/         # Tmux config
│   └── gh/           # GitHub CLI
├── .zshrc            # Zsh config
├── .bashrc           # Bash config
└── setup             # Install script
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

## Commands

```shell
./setup              # Install
./setup uninstall    # Remove
./setup health       # Check status
./setup --dry-run    # Preview
./setup --verbose    # Detailed output
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guide.

## License

[MIT](LICENSE)
