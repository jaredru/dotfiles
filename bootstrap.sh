#!/usr/bin/env zsh

# set our default xdg config path, but only if it's not already set
[[ -z $XDG_CONFIG_HOME ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z $XDG_CACHE_HOME ]]  && export XDG_CACHE_HOME="$HOME/.cache"

# check if our config directory contains our dotfiles repo
if [[ -d $XDG_CONFIG_HOME/.git ]]; then
    # make sure it's up to date
    echo "Updating dotfiles repo in $XDG_CONFIG_HOME"
    pushd $XDG_CONFIG_HOME
    git pull
    git submodule update --init --recursive
    popd
else
    # clone it
    echo "Cloning dotfiles repo to $XDG_CONFIG_HOME"
    git clone --recursive https://github.com/fouvrai/dotfiles $XDG_CONFIG_HOME
fi

# symlink all the appropriate files
echo "Setting up symlinks in $HOME"
symlink_files=($XDG_CONFIG_HOME/**/*.symlink)

for file in $symlink_files; do
    local home_file=$HOME/.$(basename "${file%.symlink}")

    if [[ ! -f $home_file ]]; then
        ln -s $file $home_file
    else
        echo "File '$home_file' already exists."
    fi
done

echo "Sourcing zsh config"
source $XDG_CONFIG_HOME/zsh/zshenv.symlink

