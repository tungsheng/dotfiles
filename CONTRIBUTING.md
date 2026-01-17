# Contributing

Developer guide for maintaining and extending this dotfiles repository.

## Quick Reference

```shell
./setup              # Install
./setup --dry-run    # Preview changes
./setup health       # Check status
./setup uninstall    # Remove
./setup --verbose    # Detailed output
```

## Project Structure

```
dotfiles/
├── setup                    # Main install script
├── .stow-local-ignore       # Files excluded from symlinks
├── .zshrc                   # Zsh configuration
├── .bashrc                  # Bash configuration
├── .config/
│   ├── nvim/                # Neovim (NvChad)
│   ├── tmux/                # Tmux configuration
│   ├── alacritty/           # Terminal emulator
│   ├── gh/                  # GitHub CLI
│   └── shell/
│       └── aliases.sh       # Shared shell aliases
└── docs/
    ├── README.md            # User documentation
    ├── KEYBINDINGS.md       # Keybinding reference
    ├── CONTRIBUTING.md      # This file
    └── CLAUDE.md            # AI assistant context
```

## Setup Script Architecture

The `setup` script is organized into sections:

| Section | Description |
|---------|-------------|
| **Configuration** | Data arrays at top for easy editing |
| **Logging** | Consistent output formatting |
| **Helpers** | Utility functions |
| **Commands** | `cmd_install`, `cmd_uninstall`, `cmd_health` |
| **Install Helpers** | OS-specific installation logic |
| **Main** | Argument parsing and dispatch |

### Configuration Arrays

All configurable data is at the top of the script:

```bash
# Dependencies: cmd|brew|dnf|apt (use - to skip)
DEPS=(
    "stow|stow|stow|stow"
    "nvim|neovim|neovim|neovim"  # cmd differs from package
    "fd|fd|fd-find|fd-find"      # Package name differs
    "rg|ripgrep|ripgrep|ripgrep" # cmd differs from package
    "zoxide|zoxide|-|zoxide"     # Not in DNF repos
    "-||-git|git"                # Linux only (skip health check)
)

# macOS fonts
CASKS=(
    "font-jetbrains-mono-nerd-font"
)

# Files managed by stow
MANAGED_FILES=(.zshrc .bashrc .config/nvim ...)

# External resources: path|url|type|name
EXTRAS=(
    "$HOME/.git-prompt.sh|https://...|curl|git-prompt.sh"
)

# Cleanup paths: path|display_name
CLEANUPS=(
    "$HOME/.config/alacritty/themes|Alacritty themes"
)
```

### Logging Functions

| Function | Purpose | Example Output |
|----------|---------|----------------|
| `log_header` | Script banner | `dotfiles v1.0.0` |
| `log_info` | Action starting | `:: Installing packages...` |
| `log_success` | Success | `✓  Symlinks created` |
| `log_warn` | Warning | `!  File exists but not symlinked` |
| `log_error` | Error | `✗  stow not found` |
| `log_dim` | Secondary info | `   OS: macos` |
| `log_step` | Step header | `[1/4] Backup existing configs` |
| `log_result` | Summary | `Results: 12 passed 0 failed` |

## Common Tasks

### Add a New Dependency

1. Add to `DEPS` array in `setup`:
   ```bash
   DEPS=(
       ...
       "cmd|brew-pkg|dnf-pkg|apt-pkg"
   )
   ```
2. First column is the **command name** (for health check)
3. Use `-` to skip: unavailable package manager or skip health check
4. Example: `"rg|ripgrep|ripgrep|ripgrep"` - command is `rg`, package is `ripgrep`

### Add a New Dotfile

1. Place file in correct location (root or `.config/`)
2. Add to `MANAGED_FILES` array if it needs backup/health tracking
3. Run `stow --restow .` to create symlink

### Add a New External Resource

1. Add to `EXTRAS` array:
   ```bash
   EXTRAS=(
       ...
       "$HOME/.new-file|https://example.com/file|curl|Display Name"
   )
   ```
2. Type can be `curl` (single file) or `git` (repository)

### Exclude a File from Stow

Add pattern to `.stow-local-ignore`:
```
\.myfile
mydir/
```

### Add a macOS Font

Add to `CASKS` array:
```bash
CASKS=(
    ...
    "font-new-font-nerd-font"
)
```

## Shell Configuration

### Aliases

Shared aliases go in `.config/shell/aliases.sh` (sourced by both Zsh and Bash).

Shell-specific aliases:
- **Zsh**: Use OMZ plugins or add to `.zshrc`
- **Bash**: Add to `.bashrc`

### Zsh Plugins

Managed by Zinit in `.zshrc`:

```bash
# Regular plugins
zinit light author/plugin-name

# OMZ snippets
zinit snippet OMZP::plugin-name
```

## Neovim Configuration

Based on NvChad. Custom configs in `.config/nvim/lua/`:

| File | Purpose |
|------|---------|
| `chadrc.lua` | Theme, UI overrides |
| `mappings.lua` | Custom keybindings |
| `options.lua` | Editor options |
| `plugins/init.lua` | Additional plugins |
| `configs/*.lua` | Plugin configurations |

### Add a Neovim Plugin

Add to `plugins/init.lua`:
```lua
{
    "author/plugin-name",
    event = "VeryLazy",  -- Lazy load
    config = function()
        require("plugin-name").setup()
    end,
},
```

## Tmux Configuration

Config: `.config/tmux/tmux.conf`

Plugins managed by TPM. Add new plugin:
```bash
set -g @plugin 'author/plugin-name'
```

Then press `prefix I` to install.

## Testing Changes

```shell
# Preview what setup will do
./setup --dry-run

# Check current installation status
./setup health

# Verbose output for debugging
./setup --verbose

# Test on fresh system (use VM or container)
docker run -it ubuntu:22.04 bash
```

## Code Style

- **Bash**: Use `shellcheck` for linting
- **Lua**: Use `stylua` for formatting (config in `.config/nvim/.stylua.toml`)
- **Indentation**: 4 spaces for bash, 2 spaces for lua
- **Comments**: Explain "why", not "what"

## Release Checklist

1. Update `VERSION` in `setup` script
2. Test on macOS and Linux
3. Run `./setup health` to verify
4. Update documentation if needed
5. Commit with descriptive message
