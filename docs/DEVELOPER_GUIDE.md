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

### Dependencies (`DEPS`)

Format: `"command | brew | dnf | apt"` — use `-` to skip.

```bash
DEPS=(
    "nvim     | neovim    | neovim    | neovim"     # Same package name
    "fd       | fd        | fd-find   | fd-find"    # Different apt/dnf name
    "zoxide   | zoxide    | -         | zoxide"     # Not in dnf
    "-        |           | git       | git"        # Linux only (no health check)
)
```

### Managed Files (`MANAGED_FILES`)

Files backed up before install and checked by `health`:

```bash
MANAGED_FILES=(.zshrc .bashrc .config/nvim ...)
```

### Extras (`EXTRAS`)

External resources downloaded during install:

```bash
# Format: "path|url|type|name|ref"
# - curl extras use "-" for ref
# - git extras should pin a commit hash in ref
EXTRAS=(
    "$HOME/.config/tmux/plugins/tpm|https://...|git|tpm|<commit>"
    "$XDG_DATA_HOME/example/file|https://...|curl|example|-"
)
```

### Cleanups (`CLEANUPS`)

Paths offered for removal during uninstall:

```bash
CLEANUPS=(
    "$HOME/.config/alacritty/themes|Alacritty themes"
    "$XDG_DATA_HOME/git|Legacy git-prompt.sh"
    "$XDG_DATA_HOME/zinit|Legacy Zinit"
    "$XDG_DATA_HOME/zsh/plugins|Zsh plugins"
    "$XDG_DATA_HOME/nvim|Neovim data"
    "$HOME/.config/tmux/plugins|Tmux plugins"
)
```

### Mason Packages (`.config/nvim/mason-packages.txt`)

List one Mason package id per line. Blank lines and `#` comments are ignored.

## Logging

| Function | Output | Use |
|----------|--------|-----|
| `log_ok` | ` ✓ ` | Success |
| `log_fail` | ` ✗ ` | Error |
| `log_warn` | ` ! ` | Warning |
| `log_info` | ` → ` | Action starting |
| `log_dim` | `   ` | Secondary info |
| `log_step` | `[step/total]` | Progress |

## Common Tasks

### Add a Dependency

1. Add to `DEPS` array in `dot`
2. Test on target OS

```bash
"newcmd|brew-pkg|dnf-pkg|apt-pkg"
```

### Add a Mason Package

1. Add the package id to `.config/nvim/mason-packages.txt`
2. Update Neovim LSP/formatter/parser config if needed
3. Run `nvim --headless "+MasonInstallAll" +qa`

### Add a Dotfile

1. Place file in repo (root or `.config/`)
2. Add to `MANAGED_FILES` if it needs backup/health tracking
3. Run `./dot install -n` to preview changes
4. Run `./dot install` (or `stow .` directly)

### Add External Resource

Add to `EXTRAS` array:

```bash
"$HOME/path|https://url|curl|name|-"           # Single file
"$HOME/path|https://url|git|name|<commit>"     # Git repo
```

Pin git extras to a commit so installs stay reproducible.

### Exclude from Stow

Add regex to `.stow-local-ignore`:

```
\.myfile
mydir/
```

## Tool Configuration

| Tool | Config | Runtime Model | Add Plugin |
|------|--------|---------------|------------|
| Zsh | `.zshrc` + `.config/shell/zsh.sh` | Pinned local checkouts | Add a pinned git extra in `dot` and source it from `.config/shell/zsh.sh` |
| Neovim | `.config/nvim/` | Lazy.nvim | `lua/plugins/init.lua` |
| Tmux | `.config/tmux/` | TPM | `set -g @plugin 'author/name'` |

### Key Files

- **Neovim plugins**: `.config/nvim/lua/plugins/init.lua`
- **Neovim keybindings**: `.config/nvim/lua/mappings.lua`
- **Neovim LSP**: `.config/nvim/lua/configs/lspconfig.lua`
- **Neovim filetypes**: `.config/nvim/lua/configs/filetypes.lua`
- **Neovim Mason packages**: `.config/nvim/mason-packages.txt`
- **Shared aliases**: `.config/shell/aliases.sh`
- **Platform bootstrap**: `.config/shell/platform.sh`
- **Shared shell bootstrap**: `.config/shell/common.sh`
- **Bash shell setup**: `.config/shell/bash.sh`
- **Zsh shell setup**: `.config/shell/zsh.sh`
- **Environment loader**: `.config/shell/env-loader.sh`

## Testing

```shell
./dot install -n     # Preview changes
./dot install -v     # Verbose output
./dot update         # Pull latest + sync extras + update plugins
./dot status         # Quick overview
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

1. Update `VERSION` file (in repo root)
2. Test on macOS and Linux
3. Run `./dot health`
4. Update `docs/CHANGELOG.md`
5. Tag and push:
   ```shell
   git tag -a v1.x.0 -m "v1.x.0 - Description"
   git push origin v1.x.0
   ```
