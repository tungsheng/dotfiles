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

# Run setup script (installs dependencies and creates symlinks)
./setup
```

### Linux

```shell
# Install dependencies (Debian/Ubuntu)
sudo apt install stow neovim fd-find ripgrep fzf zoxide tmux

# Clone and stow
git clone https://github.com/tungsheng/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow .
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

### Tmux

- **Prefix**: `Ctrl+Space`
- **Pane navigation**: `prefix + h/j/k/l`
- **Window navigation**: `Shift + Left/Right`
- **Install plugins**: `prefix + I`

### Neovim

See NvChad documentation for default keybindings.

## License

MIT License - see [LICENSE](LICENSE) for details.
