# Keybindings Reference

Quick reference for all custom keybindings in this dotfiles setup.

## Tmux

**Prefix**: `Ctrl+Space` (changed from default `Ctrl+b`)

### Pane Navigation

| Keybinding | Action |
|------------|--------|
| `prefix h` | Move to left pane |
| `prefix j` | Move to down pane |
| `prefix k` | Move to up pane |
| `prefix l` | Move to right pane |
| `Alt+←/→/↑/↓` | Move to pane (no prefix needed) |
| `Ctrl+h/j/k/l` | Move between tmux panes AND vim splits (seamless) |

### Window Navigation

| Keybinding | Action |
|------------|--------|
| `Shift+←` | Previous window |
| `Shift+→` | Next window |
| `Alt+H` | Previous window |
| `Alt+L` | Next window |

### Pane Management

| Keybinding | Action |
|------------|--------|
| `prefix "` | Split pane vertically (current path) |
| `prefix %` | Split pane horizontally (current path) |

### Copy Mode (vi-style)

| Keybinding | Action |
|------------|--------|
| `prefix [` | Enter copy mode |
| `v` | Begin selection |
| `Ctrl+v` | Toggle rectangle selection |
| `y` | Copy selection and exit |

### Plugins

| Keybinding | Action |
|------------|--------|
| `prefix I` | Install TPM plugins |
| `prefix U` | Update TPM plugins |

## Neovim

**Leader**: `Space`

### Window Navigation

| Keybinding | Action |
|------------|--------|
| `Ctrl+h` | Navigate left (works across tmux panes) |
| `Ctrl+j` | Navigate down (works across tmux panes) |
| `Ctrl+k` | Navigate up (works across tmux panes) |
| `Ctrl+l` | Navigate right (works across tmux panes) |

### Git (Custom)

| Keybinding | Action |
|------------|--------|
| `<leader>gs` | Open Neogit status |
| `<leader>gw` | List git worktrees |
| `<leader>ga` | Create git worktree |

### Terminal

| Keybinding | Action |
|------------|--------|
| `ESC` | Exit terminal mode (in terminal buffer) |

### NvChad Defaults

For a complete list of NvChad keybindings, run `:NvCheatsheet` in Neovim.

Common ones:

| Keybinding | Action |
|------------|--------|
| `<leader>ff` | Find files (Telescope) |
| `<leader>fw` | Live grep (Telescope) |
| `<leader>fb` | Find buffers (Telescope) |
| `<leader>fh` | Help tags (Telescope) |
| `<leader>th` | Change theme |
| `<leader>ch` | Open cheatsheet |
| `<leader>e` | Toggle file tree (nvim-tree) |
| `<leader>x` | Close buffer |
| `Tab` | Next buffer |
| `Shift+Tab` | Previous buffer |

## Zsh

### History Navigation

| Keybinding | Action |
|------------|--------|
| `Ctrl+p` | Previous command in history |
| `Ctrl+n` | Next command in history |
| `Ctrl+r` | Fuzzy search history (fzf) |

### Editing

| Keybinding | Action |
|------------|--------|
| `Alt+w` | Kill region |
| `Tab` | Fuzzy completion (fzf-tab) |

### Aliases

See `.config/shell/aliases.sh` for shared aliases.

**Navigation:**
- `..` / `...` / `....` - Go up directories

**Listing:**
- `ll` - `ls -la`
- `la` - `ls -lathr`

**Editors:**
- `vim` / `v` - Opens Neovim

**Git (zsh uses OMZP::git plugin):**
- `gst` - git status
- `ga` - git add
- `gc` - git commit
- `gco` - git checkout
- `gp` - git push
- `gl` - git pull
- `gd` - git diff

Run `alias | grep git` for full list.

## Cross-Tool Navigation

The `vim-tmux-navigator` plugin enables seamless navigation:

```
┌─────────────────────────────────────────┐
│  Tmux Pane 1    │  Tmux Pane 2          │
│  ┌───────────┐  │                       │
│  │ Vim Split │  │  Terminal             │
│  │     1     │  │                       │
│  ├───────────┤  │                       │
│  │ Vim Split │  │                       │
│  │     2     │  │                       │
│  └───────────┘  │                       │
└─────────────────────────────────────────┘

Ctrl+h/j/k/l moves between ALL of these seamlessly!
```
