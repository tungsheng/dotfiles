# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a dotfiles repository managed with GNU Stow. It contains configuration for a modern terminal development environment on macOS and Linux.

## Key Commands

```shell
# Install dotfiles (macOS - installs Homebrew dependencies + creates symlinks)
./setup

# Create/update symlinks manually
stow --target="$HOME" --restow .

# Linux dependencies (manual install required)
sudo apt install stow neovim fd-find ripgrep fzf zoxide tmux
```

## Architecture

**Symlink Management**: Uses GNU Stow to symlink dotfiles from this repo to `$HOME`. The `.stow-local-ignore` file excludes non-config files (README, LICENSE, setup script, Brewfile) from being symlinked.

**Directory Structure**:
- `.config/` - XDG-compliant configs (nvim, tmux, alacritty, gh)
- Root-level dotfiles (`.zshrc`, `.bashrc`) - Shell configurations

**Shell (Zsh)**: Uses Zinit plugin manager with Powerlevel10k prompt. Key plugins: zsh-syntax-highlighting, zsh-completions, zsh-autosuggestions, fzf-tab.

**Neovim**: NvChad-based configuration (v2.5) with Lazy.nvim package manager. Custom configs in `.config/nvim/lua/` - `chadrc.lua` for theme, `mappings.lua` for keybinds, `plugins/` for additional plugins.

**Tmux**: Prefix is `Ctrl+Space`. Uses TPM (Tmux Plugin Manager). Plugins: tmux-sensible, vim-tmux-navigator, catppuccin-tmux, tmux-yank. Vi-mode enabled for copy mode.

**Alacritty**: Tokyo Night theme, JetBrainsMono Nerd Font.
