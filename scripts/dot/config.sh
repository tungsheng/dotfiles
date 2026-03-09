# shellcheck shell=bash
# Shared configuration for the dot installer.
# shellcheck disable=SC2034

# Version: prefer git tag, fall back to VERSION file
get_version() {
    local ver
    if ver=$(git -C "$DOTFILES_DIR" describe --tags --always 2>/dev/null); then
        echo "${ver#v}"  # strip leading 'v'
    elif [[ -f "$DOTFILES_DIR/VERSION" ]]; then
        tr -d '[:space:]' < "$DOTFILES_DIR/VERSION"
    else
        echo "unknown"
    fi
}

VERSION="$(get_version)"
DRY_RUN=false
VERBOSE=false
USE_SHELL=""
INSTALL_STEPS=6
HEALTH_STEPS=5
UPDATE_STEPS=3
UNINSTALL_STEPS=2

# XDG Base Directories
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
STATE_DIR="$XDG_STATE_HOME/dotfiles"
STATE_FILE="$STATE_DIR/state"
MASON_PKG_FILE="$DOTFILES_DIR/.config/nvim/mason-packages.txt"

# Dependencies table: command | brew | dnf | apt
# - Use "-" to indicate package is unavailable for that package manager
# - Use "-" for command to skip health check (install-only packages)
#
# Format: "command | brew-pkg | dnf-pkg | apt-pkg"
DEPS=(
    "stow     | stow      | stow      | stow"
    "nvim     | neovim    | neovim    | neovim"
    "fd       | fd        | fd-find   | fd-find"
    "rg       | ripgrep   | ripgrep   | ripgrep"
    "fzf      | fzf       | fzf       | fzf"
    "zoxide   | zoxide    | -         | zoxide"       # Not in dnf repos
    "tmux     | tmux      | tmux      | tmux"
    "uv       | uv        | -         | -"            # Python package manager
    "-        |           | git       | git"          # Install-only (skip health check)
    "-        |           | curl      | curl"
    "-        |           | zsh       | zsh"
    "-        |           | unzip     | unzip"
)

CASKS=("font-jetbrains-mono-nerd-font" "font-hurmit-nerd-font")

MANAGED_FILES=(.zshrc .bashrc .bash_profile .config/nvim .config/tmux/tmux.conf .config/alacritty/alacritty.toml .config/gh/config.yml .config/ruff .config/shell)

# Extras: path|url|type|name (evaluated after XDG vars set)
EXTRAS=(
    "$HOME/.config/alacritty/themes|https://github.com/alacritty/alacritty-theme|git|alacritty-themes|d6aa290133caac2ac297b21cd9491596ac7297c3"
    "$HOME/.config/tmux/plugins/tpm|https://github.com/tmux-plugins/tpm|git|tpm|99469c4a9b1ccf77fade25842dc7bafbc8ce9946"
    "$XDG_DATA_HOME/zsh/plugins/powerlevel10k|https://github.com/romkatv/powerlevel10k|git|powerlevel10k|b97926675aba2d8465325d786cc69de9d9fdec84"
    "$XDG_DATA_HOME/zsh/plugins/zsh-autosuggestions|https://github.com/zsh-users/zsh-autosuggestions|git|zsh-autosuggestions|85919cd1ffa7d2d5412f6d3fe437ebdbeeec4fc5"
    "$XDG_DATA_HOME/zsh/plugins/zsh-completions|https://github.com/zsh-users/zsh-completions|git|zsh-completions|7dd26c5d5c3fabd630b748bd49ebd9cf02bd57e9"
    "$XDG_DATA_HOME/zsh/plugins/zsh-syntax-highlighting|https://github.com/zsh-users/zsh-syntax-highlighting|git|zsh-syntax-highlighting|5eb677bb0fa9a3e60f0eff031dc13926e093df92"
    "$XDG_DATA_HOME/zsh/plugins/fzf-tab|https://github.com/Aloxaf/fzf-tab|git|fzf-tab|cbdc58226a696688d08eae63d8e44f4b230fa3dd"
)

# Cleanup: path|name
CLEANUPS=(
    "$HOME/.config/alacritty/themes|Alacritty themes"
    "$XDG_DATA_HOME/git|Legacy git-prompt.sh"
    "$XDG_DATA_HOME/zinit|Legacy Zinit"
    "$XDG_DATA_HOME/zsh/plugins|Zsh plugins"
    "$XDG_DATA_HOME/nvim|Neovim data"
    "$HOME/.config/tmux/plugins|Tmux plugins"
)
