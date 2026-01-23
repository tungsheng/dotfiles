# Keybindings

## Navigation (vim-tmux-navigator)

Seamless movement across Neovim splits and Tmux panes:

```
┌──────────────────────────────────────┐
│  Tmux Pane      │  Tmux Pane         │
│  ┌──────────┐   │                    │
│  │ Vim Split│   │  Terminal          │
│  ├──────────┤   │                    │
│  │ Vim Split│   │                    │
│  └──────────┘   │                    │
└──────────────────────────────────────┘
       Ctrl+h/j/k/l moves everywhere
```

| Key | Direction |
|-----|-----------|
| `Ctrl+h` | Left |
| `Ctrl+j` | Down |
| `Ctrl+k` | Up |
| `Ctrl+l` | Right |

## Tmux

**Prefix**: `Ctrl+Space`

| Key | Action |
|-----|--------|
| `prefix "` | Split horizontal |
| `prefix %` | Split vertical |
| `prefix z` | Zoom pane (toggle) |
| `Shift+←/→` | Prev/next window |
| `prefix [` | Copy mode (vi) |
| `v` / `y` | Select / yank (in copy mode) |
| `prefix I` | Install plugins |

## Neovim

**Leader**: `Space`

| Key | Action |
|-----|--------|
| `<leader>ff` | Find files |
| `<leader>fw` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>e` | File tree |
| `<leader>x` | Close buffer |
| `Tab` / `S-Tab` | Next/prev buffer |
| `<leader>gs` | Git status (Neogit) |
| `<leader>gw` | Git worktree list |
| `<leader>ga` | Git worktree add |
| `<leader>th` | Change theme |
| `<leader>ch` | Cheatsheet |

### Terminal

| Key | Action |
|-----|--------|
| `<leader>h` | Horizontal terminal |
| `<leader>v` | Vertical terminal |
| `<A-h>` | Toggle horizontal terminal |
| `<A-v>` | Toggle vertical terminal |
| `<A-i>` | Toggle floating terminal |
| `ESC` | Exit terminal mode (to normal) |

Run `:NvCheatsheet` for full NvChad bindings.

## Zsh

| Key | Action |
|-----|--------|
| `Ctrl+r` | Fuzzy history search (fzf) |
| `Tab` | Fuzzy completion (fzf-tab) |
| `Ctrl+p/n` | Prev/next history |

### Aliases

```shell
# Navigation
..  ...  ....      # Up directories

# Listing
ll                 # ls -la
la                 # ls -lathr

# Git (OMZP::git)
gst  ga  gc  gco   # status, add, commit, checkout
gp   gl  gd        # push, pull, diff
```

Run `alias | grep git` for full list.

## CLI Tools

### fzf (fuzzy finder)

```shell
# Interactive selection
vim $(fzf)                    # Open file
cd $(find . -type d | fzf)    # cd to directory
kill $(ps aux | fzf | awk '{print $2}')

# Piping
cat file.txt | fzf            # Filter lines
history | fzf                 # Search history
```

| Key (in fzf) | Action |
|--------------|--------|
| `Ctrl+j/k` | Move down/up |
| `Ctrl+n/p` | Move down/up (alt) |
| `Enter` | Select |
| `Tab` | Multi-select |
| `Ctrl+c` | Cancel |

### fd (find replacement)

```shell
fd pattern              # Find files matching pattern
fd -e js                # Find by extension
fd -H pattern           # Include hidden files
fd -t d                 # Directories only
fd -t f                 # Files only
fd -x cmd {}            # Execute command on results
fd pattern -X vim       # Open all matches in vim
```

### rg (ripgrep)

```shell
rg pattern              # Search file contents
rg -i pattern           # Case insensitive
rg -w word              # Whole word
rg -t js pattern        # File type filter
rg -g '*.md' pattern    # Glob filter
rg -l pattern           # Files only (no content)
rg -C 3 pattern         # Show 3 lines context
rg -A 2 -B 2 pattern    # 2 lines after/before
rg --hidden pattern     # Include hidden files
rg -F 'literal.string'  # Fixed string (no regex)
```

### Combined workflows

```shell
# Edit files containing pattern
vim $(rg -l pattern)

# Find and grep
fd -e py | xargs rg 'def '

# Interactive file search
fd | fzf | xargs vim

# Preview while searching
fzf --preview 'cat {}'
rg pattern --json | fzf
```
