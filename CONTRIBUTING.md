# Contributing

Developer guide for maintaining and extending this dotfiles repository.

## Commands

```shell
./setup              # Install
./setup uninstall    # Remove
./setup health       # Check status
./setup --dry-run    # Preview
./setup --verbose    # Detailed output
```

## Structure

```
dotfiles/
├── .zshrc                   # Zsh config
├── .bashrc                  # Bash config
├── .bash_profile            # Bash login config
├── .config/
│   ├── nvim/                # Neovim (NvChad)
│   ├── tmux/                # Tmux config
│   ├── alacritty/           # Terminal emulator
│   ├── gh/                  # GitHub CLI
│   └── shell/aliases.sh     # Shared aliases
├── setup                    # Install script
├── .stow-local-ignore       # Stow exclusions
├── .gitignore               # Git exclusions
├── README.md                # User guide
├── KEYBINDINGS.md           # Key reference
├── CONTRIBUTING.md          # This file
└── CLAUDE.md                # AI context
```

## Setup Script

### Architecture

| Section | Lines | Description |
|---------|-------|-------------|
| Configuration | 1-55 | Data arrays (deps, files, extras) |
| Logging | 56-95 | Output formatting functions |
| Helpers | 97-146 | Utility functions |
| Commands | 148-313 | `cmd_health`, `cmd_uninstall`, `cmd_install` |
| Install Helpers | 315-404 | OS-specific installation |
| Main | 406-432 | Argument parsing |

### Configuration Arrays

```bash
# Dependencies: cmd|brew|dnf|apt (use - to skip)
DEPS=(
    "stow|stow|stow|stow"
    "nvim|neovim|neovim|neovim"  # cmd differs from package
    "fd|fd|fd-find|fd-find"      # Package name differs
    "rg|ripgrep|ripgrep|ripgrep"
    "zoxide|zoxide|-|zoxide"     # Not in DNF repos
    "-||-git|git"                # Linux only
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

| Function | Output |
|----------|--------|
| `log_header` | `dotfiles v1.0.0` |
| `log_info` | `:: Installing...` |
| `log_success` | `✓  Done` |
| `log_warn` | `!  Warning` |
| `log_error` | `✗  Error` |
| `log_dim` | `   (secondary)` |
| `log_step` | `[1/4] Step` |
| `log_result` | `Results: N passed` |

## Common Tasks

### Add a Dependency

```bash
# In setup, add to DEPS array:
"cmd|brew-pkg|dnf-pkg|apt-pkg"

# Examples:
"rg|ripgrep|ripgrep|ripgrep"  # cmd differs from package
"zoxide|zoxide|-|zoxide"       # Not in DNF
"-||-git|git"                  # Linux only
```

### Add a Dotfile

1. Place file in repo (root or `.config/`)
2. Add to `MANAGED_FILES` if needed for backup/health
3. Run `stow --restow .`

### Add an External Resource

```bash
# In setup, add to EXTRAS array:
"$HOME/path|https://url|type|Name"

# type: curl (file) or git (repo)
```

### Exclude from Stow

Add regex pattern to `.stow-local-ignore`:
```
\.myfile
mydir/
```

### Add macOS Font

```bash
# In setup, add to CASKS array:
"font-name-nerd-font"
```

## Tool Configuration

### Zsh (`.zshrc`)

- Plugin manager: Zinit
- Prompt: Powerlevel10k
- Plugins via: `zinit light author/plugin`
- OMZ snippets via: `zinit snippet OMZP::name`

### Neovim (`.config/nvim/`)

- Base: NvChad
- Plugin manager: Lazy.nvim
- Custom plugins: `lua/plugins/init.lua`
- Keybindings: `lua/mappings.lua`
- LSP config: `lua/configs/lspconfig.lua`

### Tmux (`.config/tmux/`)

- Plugin manager: TPM
- Add plugin: `set -g @plugin 'author/name'`
- Install: `prefix I`
- Prefix: `Ctrl+Space`

### Aliases (`.config/shell/aliases.sh`)

Shared by Zsh and Bash. Shell-specific aliases go in respective rc files.

## Testing

```shell
./setup --dry-run    # Preview
./setup health       # Verify
./setup --verbose    # Debug

# Fresh system test
docker run -it ubuntu:22.04 bash
```

## Code Style

- Bash: 4 spaces, shellcheck
- Lua: 2 spaces, stylua
- Comments: Explain "why" not "what"

## Release

1. Update `VERSION` in setup
2. Test on macOS and Linux
3. Run `./setup health`
4. Update docs if needed
