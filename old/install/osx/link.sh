#!/bin/bash

echo -e "\nCreating symlinks"
echo "=============================="
linkables=$( find -H "$DOTFILES" -maxdepth 3 -name '*.symlink' )
for file in $linkables ; do
    echo "Creating symlink for $file"
    target="$HOME/.$( basename $file '.symlink' )"
    ln -sf $file $target
done

echo -e "\n\ninstalling to ~/.config"
echo "=============================="
if [ ! -d $HOME/.config/nvim/lua/user ]; then
    echo "Creating ~/.config"
    mkdir -p $HOME/.config/nvim/lua/user
fi
# configs=$( find -path "$DOTFILES/config.symlink" -maxdepth 1 )

init=$( find -H "$DOTFILES/config/nvim" -maxdepth 1 -name '*.symlink' )
echo "Creating symlink for $init"
target="$HOME/.config/nvim/$( basename $init '.symlink' )"
ln -sf $init $target

LUA="lua/user"
for lua in $DOTFILES/config/nvim/$LUA/*; do
    echo "Creating symlink for $lua"
    target="$HOME/.config/nvim/$LUA/$( basename $lua '.symlink' )"
    ln -sf $lua $target
done
