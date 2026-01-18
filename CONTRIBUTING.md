# Contributing

Developer guide for maintaining and extending this dotfiles repository.

## Commands

```shell
./dot                 # Show help
./dot install         # Install
./dot uninstall       # Remove
./dot health          # Check status
./dot install -n      # Preview (dry-run)
./dot install -v      # Verbose output
```

## Structure

```
dotfiles/
├── .zshrc                   # Zsh config
├── .bashrc                  # Bash config
├── .bash_profile            # Bash login config
├── .config/
│   ├── nvim/                # Neovim (Lazy.nvim)
│   ├── tmux/                # Tmux (TPM)
│   ├── alacritty/           # Terminal emulator
│   ├── gh/                  # GitHub CLI
│   └── shell/aliases.sh     # Shared aliases
├── dot                      # Install script (bash 3.2+)
├── .stow-local-ignore       # Stow exclusions
├── README.md                # User guide
├── KEYBINDINGS.md           # Key reference
├── CONTRIBUTING.md          # This file
└── CLAUDE.md                # AI context
```

## Install Script (`dot`)

### Sections

| Section | Description |
|---------|-------------|
| Configuration | Data arrays (deps, files, extras) |
| Output | Logging functions |
| Helpers | Utility functions |
| Commands | `cmd_health`, `cmd_uninstall`, `cmd_install` |
| Install Helpers | OS-specific installation |
| Main | Argument parsing |

### Configuration Arrays

```bash
# Dependencies: cmd|brew|dnf|apt (use - to skip)
DEPS=(
    "stow|stow|stow|stow"
    "nvim|neovim|neovim|neovim"  # cmd differs from package
    "fd|fd|fd-find|fd-find"      # package name varies by OS
    "zoxide|zoxide|-|zoxide"     # not in DNF repos
    "-||-git|git"                # Linux only
)

# macOS fonts
CASKS=("font-jetbrains-mono-nerd-font" "font-hurmit-nerd-font")

# Files managed by stow
MANAGED_FILES=(.zshrc .bashrc .config/nvim ...)

# External resources: path|url|type|name
EXTRAS=(
    "$HOME/.git-prompt.sh|https://...|curl|git-prompt"
)

# Cleanup paths: path|name
CLEANUPS=(
    "$HOME/.config/alacritty/themes|Alacritty themes"
)
```

### Logging Functions

| Function | Output |
|----------|--------|
| `log_ok` | ` ✓  Done` |
| `log_fail` | ` ✗  Error` |
| `log_warn` | ` !  Warning` |
| `log_info` | ` →  Action` |
| `log_dim` | `     (secondary)` |
| `log_step` | ` [1/5] Step` |
| `log_summary` | ` 5 ok  1 failed` |

## Common Tasks

### Add a Dependency

```bash
# In dot, add to DEPS array:
"cmd|brew-pkg|dnf-pkg|apt-pkg"

# Examples:
"rg|ripgrep|ripgrep|ripgrep"  # cmd differs from package
"zoxide|zoxide|-|zoxide"       # not in DNF
"-||-git|git"                  # Linux only
```

### Add a Dotfile

1. Place file in repo (root or `.config/`)
2. Add to `MANAGED_FILES` if needed for backup/health
3. Run `stow --restow .`

### Add an External Resource

```bash
# In dot, add to EXTRAS array:
"$HOME/path|https://url|type|name"

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
# In dot, add to CASKS array:
"font-name-nerd-font"
```

## Tool Configuration

### Zsh (`.zshrc`)

- Plugin manager: Zinit
- Prompt: Powerlevel10k
- Plugins: `zinit light author/plugin`
- OMZ snippets: `zinit snippet OMZP::name`

### Neovim (`.config/nvim/`)

- Plugin manager: Lazy.nvim
- Custom plugins: `lua/plugins/init.lua`
- Keybindings: `lua/mappings.lua`
- LSP config: `lua/configs/lspconfig.lua`

### Tmux (`.config/tmux/`)

- Plugin manager: TPM
- Add plugin: `set -g @plugin 'author/name'`
- Install: `Ctrl+Space I`
- Prefix: `Ctrl+Space`

### Aliases (`.config/shell/aliases.sh`)

Shared by Zsh and Bash. Shell-specific aliases go in respective rc files.

## Testing

```shell
./dot install -n     # Preview
./dot health         # Verify
./dot install -v     # Debug

# Fresh system test
docker run -it ubuntu:22.04 bash
```

## Code Style

- Bash: POSIX-compatible where possible, bash 3.2+ features ok
- Lua: 2 spaces, stylua
- Comments: Explain "why" not "what"

## Release

1. Update `VERSION` in `dot`
2. Test on macOS and Linux
3. Run `./dot health`
4. Update docs if needed
