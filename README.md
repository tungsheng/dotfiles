# Dotfiles

Tony's dotfiles for a modern terminal development environment.

## What's Included

- **Zsh** - Shell with Zinit plugin manager and Powerlevel10k prompt
- **Neovim** - NvChad-based configuration with LSP support
- **Tmux** - Terminal multiplexer with vim-style navigation
- **Alacritty** - GPU-accelerated terminal emulator

## Installation

### macOS

```shell
# Clone the repository
git clone https://github.com/tungsheng/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Preview what will be installed (dry run)
./setup --dry-run

# Run setup script (installs dependencies and creates symlinks)
./setup
```

### Linux

```shell
# Clone the repository
git clone https://github.com/tungsheng/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Run setup script (auto-detects distro and installs dependencies)
./setup
```

#### Manual Installation by Distro

**Debian/Ubuntu:**
```shell
sudo apt install -y stow neovim fd-find ripgrep fzf zoxide tmux zsh
```

**AlmaLinux/RHEL/CentOS 9:**
```shell
sudo dnf install -y epel-release
sudo dnf install -y stow neovim fd-find ripgrep fzf tmux zsh
# zoxide not in repos - install manually:
curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash
```

**Fedora:**
```shell
sudo dnf install -y stow neovim fd-find ripgrep fzf zoxide tmux zsh
```

## Manual Installation

If you prefer to install dependencies yourself:

```shell
# Install stow
brew install stow  # macOS
# or: sudo apt install stow  # Linux

# Create symlinks
cd ~/dotfiles
stow .
```

## Post-Installation

1. Restart your terminal or run `source ~/.zshrc`
2. Run `p10k configure` to set up Powerlevel10k prompt
3. Open `nvim` to let Lazy.nvim install plugins
4. Run `tmux` and press `Ctrl+Space I` to install tmux plugins

## Uninstall

```shell
cd ~/dotfiles
./setup uninstall
```

This will:
- Remove all dotfile symlinks
- Optionally remove Alacritty themes, Zinit, Neovim data, and tmux plugins
- **Note:** Installed packages (brew/dnf/apt) are not removed

## Structure

```
dotfiles/
├── .config/
│   ├── alacritty/     # Terminal emulator config
│   ├── gh/            # GitHub CLI config
│   ├── nvim/          # Neovim config (NvChad)
│   └── tmux/          # Tmux config + plugins
├── .zshrc             # Zsh configuration
├── .bashrc            # Bash configuration
├── .bash_profile      # Bash login config
├── Brewfile           # Homebrew dependencies
└── setup              # Installation script
```

## Key Bindings

See [KEYBINDINGS.md](KEYBINDINGS.md) for complete reference.

### Quick Reference

| Tool | Key | Action |
|------|-----|--------|
| Tmux | `Ctrl+Space` | Prefix key |
| Tmux | `Ctrl+h/j/k/l` | Navigate panes (seamless with vim) |
| Tmux | `prefix I` | Install plugins |
| Neovim | `Space` | Leader key |
| Neovim | `<leader>ff` | Find files |
| Neovim | `<leader>gs` | Git status (Neogit) |
| Zsh | `Ctrl+r` | Fuzzy history search |

## Useful Commands

```shell
./setup health      # Check installation status
./setup uninstall   # Remove dotfiles
./setup --dry-run   # Preview changes
```

## License

MIT License - see [LICENSE](LICENSE) for details.
