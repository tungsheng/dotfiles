# Developer Guide

Guide for maintaining and extending this dotfiles repository.

## Script Architecture

The `dot` script (bash 3.2+) is organized into sections:

```
┌─────────────────────────────────────────────────────┐
│  Configuration    Data arrays, constants            │
├─────────────────────────────────────────────────────┤
│  Output           Colors, logging, spinner          │
├─────────────────────────────────────────────────────┤
│  Helpers          Utilities (run, has_cmd, etc.)    │
├─────────────────────────────────────────────────────┤
│  Commands         cmd_install, cmd_health, etc.     │
├─────────────────────────────────────────────────────┤
│  Install Helpers  OS-specific install functions     │
├─────────────────────────────────────────────────────┤
│  Main             Argument parsing, dispatch        │
└─────────────────────────────────────────────────────┘
```

## Configuration Arrays

### Dependencies

Format: `"command | brew | dnf | apt"` — use `-` to skip.

```bash
DEPS=(
    "nvim     | neovim    | neovim    | neovim"     # Same package name
    "fd       | fd        | fd-find   | fd-find"    # Different apt/dnf name
    "zoxide   | zoxide    | -         | zoxide"     # Not in dnf
    "-        |           | git       | git"        # Linux only (no health check)
)
```

### Managed Files

Files backed up before install and checked by `health`:

```bash
MANAGED_FILES=(.zshrc .bashrc .config/nvim ...)
```

### Extras

External resources downloaded during install:

```bash
# Format: "path|url|type|name"
EXTRAS=(
    "$XDG_DATA_HOME/git/git-prompt.sh|https://...|curl|git-prompt"
    "$HOME/.config/tmux/plugins/tpm|https://...|git|tpm"
)
```

### Cleanups

Paths offered for removal during uninstall:

```bash
CLEANUPS=(
    "$HOME/.config/alacritty/themes|Alacritty themes"
)
```

## Logging

| Function | Output | Use |
|----------|--------|-----|
| `log_ok` | ` ✓ ` | Success |
| `log_fail` | ` ✗ ` | Error |
| `log_warn` | ` ! ` | Warning |
| `log_info` | ` → ` | Action starting |
| `log_dim` | `   ` | Secondary info |
| `log_step` | `[1/5]` | Progress |

## Common Tasks

### Add a Dependency

1. Add to `DEPS` array in `dot`
2. Test on target OS

```bash
"newcmd|brew-pkg|dnf-pkg|apt-pkg"
```

### Add a Dotfile

1. Place file in repo (root or `.config/`)
2. Add to `MANAGED_FILES` if it needs backup/health tracking
3. Run `stow --restow .`

### Add External Resource

Add to `EXTRAS` array:

```bash
"$HOME/path|https://url|curl|name"   # Single file
"$HOME/path|https://url|git|name"    # Git repo
```

### Exclude from Stow

Add regex to `.stow-local-ignore`:

```
\.myfile
mydir/
```

## Tool Configuration

| Tool | Config | Plugin Manager | Add Plugin |
|------|--------|----------------|------------|
| Zsh | `.zshrc` | Zinit | `zinit light author/plugin` |
| Neovim | `.config/nvim/` | Lazy.nvim | `lua/plugins/init.lua` |
| Tmux | `.config/tmux/` | TPM | `set -g @plugin 'author/name'` |

### Key Files

- **Neovim plugins**: `lua/plugins/init.lua`
- **Neovim keybindings**: `lua/mappings.lua`
- **Neovim LSP**: `lua/configs/lspconfig.lua`
- **Shared aliases**: `.config/shell/aliases.sh`

## Testing

```shell
./dot install -n     # Preview changes
./dot install -v     # Verbose output
./dot health         # Verify install

# Fresh system test
docker run -it ubuntu:22.04 bash
docker run -it fedora:latest bash
```

## Code Style

- **Bash**: POSIX-compatible where possible, bash 3.2+ features OK
- **Lua**: 2 spaces, use stylua
- **Comments**: Explain "why" not "what"

## Release

1. Update `VERSION` file
2. Test on macOS and Linux
3. Run `./dot health`
4. Update `CHANGELOG.md`
5. Tag release: `git tag -a v1.x.0 -m "v1.x.0 - Description"`
