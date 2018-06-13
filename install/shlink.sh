#!/usr/bin/env bash

DOTFILES=$HOME/.dotfiles

echo -e "\nCreating shell script symlinks"
echo "=============================="
linkables=$( find -H "$DOTFILES" -maxdepth 3 -name '*.sh.symlink' )
echo "Creating folders"
for file in $linkables ; do
    target="/usr/local/bin/$( basename $file '.sh.symlink' )"
    if [ -e $target ]; then
        echo "~${target#$HOME} already exists... Skipping."
    else
        echo "Creating symlink for $file..."
        sudo ln -s $file $target
        echo "Creating symlink for $file completed."
    fi
done

echo "Done."
