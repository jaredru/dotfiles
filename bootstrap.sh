#!/usr/bin/env zsh
set -efu -o pipefail

title() {
    echo
    echo //
    echo // $1
    echo //
    echo
}

# inspect our environment
case "$OSTYPE" in
    darwin|darwin21.0)
        local env=mac
    ;;
    linux-gnu)
        if uname -r | grep -q microsoft; then
            local env=wsl
        else
            local env=linux
        fi
    ;;
    *)
        echo "Unexpected OSTYPE: $OSTYPE"
        return 1 2>/dev/null
        exit 1
    ;;
esac

bootstrap-env() {
    local src=${funcfiletrace[1]%:*}
    local dir=$(dirname $src)
    source "$dir/bootstrap.$env.sh"
}

# set our default xdg config path, but only if it's not already set
[[ -z "${XDG_CONFIG_HOME-}" ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z "${XDG_CACHE_HOME-}" ]]  && export XDG_CACHE_HOME="$HOME/.cache"

# check if our config directory contains our dotfiles repo
if [[ -d $XDG_CONFIG_HOME/.git ]]; then
    # if we don't have local changes, make sure it's up to date
    if (cd $XDG_CONFIG_HOME; git diff-index --quiet HEAD); then
        title "Updating dotfiles repo in $XDG_CONFIG_HOME"
        pushd $XDG_CONFIG_HOME
        git pull
        git submodule update --init --recursive
        popd
    fi
else
    # clone it
    title "Cloning dotfiles repo to $XDG_CONFIG_HOME"
    git clone --recursive https://github.com/jaredru/dotfiles $XDG_CONFIG_HOME
fi

# symlink all the appropriate files
title "Setting up symlinks in $HOME"

for file in $XDG_CONFIG_HOME/**/*.symlink; do
    local home_file=$HOME/.$(basename "${file%.symlink}")

    if [[ ! -e $home_file ]]; then
        ln -s $file $home_file
    else
        echo "File '$home_file' already exists."
    fi
done

# run system-specific bootstrap
title "Running $env bootstrap"
bootstrap-env

# bootstrap dependencies
setopt extended_glob
for file in $XDG_CONFIG_HOME/**/bootstrap.sh~$XDG_CONFIG_HOME/bootstrap.sh; do
    title "Bootstrapping $(basename $(dirname $file))"
    source "$file"
done

title "Launching ZSH"
exec zsh

