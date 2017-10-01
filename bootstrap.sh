#!/usr/bin/env zsh
set -efu -o pipefail

# set our default xdg config path, but only if it's not already set
[[ -z $XDG_CONFIG_HOME ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z $XDG_CACHE_HOME ]]  && export XDG_CACHE_HOME="$HOME/.cache"

# a simple function to indent a command's output
indent() {
    eval $@ |& sed 's/^/  /'
}

# check if our config directory contains our dotfiles repo
if [[ -d $XDG_CONFIG_HOME/.git ]]; then
    # if we don't have local changes, make sure it's up to date
    if (cd $XDG_CONFIG_HOME; git diff-index --quiet HEAD); then
        echo "Updating dotfiles repo in $XDG_CONFIG_HOME"
        pushd $XDG_CONFIG_HOME
        indent git pull
        indent git submodule update --init --recursive
        popd
    fi
else
    # clone it
    echo "Cloning dotfiles repo to $XDG_CONFIG_HOME"
    indent git clone --recursive https://github.com/fouvrai/dotfiles $XDG_CONFIG_HOME
fi

# symlink all the appropriate files
echo
echo "Setting up symlinks in $HOME"

for file in $XDG_CONFIG_HOME/**/*.symlink; do
    local home_file=$HOME/.$(basename "${file%.symlink}")

    if [[ ! -e $home_file ]]; then
        ln -s $file $home_file
    else
        indent echo "File '$home_file' already exists."
    fi
done

# ensure homebrew is installed
if ! command -v brew > /dev/null; then
    echo
    echo "Installing homebrew"
    indent /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install brew packages
casklist=$(brew cask list)
cask() {
    if [ -z "$(echo "$casklist" | grep "\b${2:-$1}\b")" ]; then
        indent brew cask install "$1"
    fi
}

cask 1password
cask appcleaner
cask docker
cask google-chrome
cask hyperdock
cask imageoptim
cask itsycal
cask java
cask kaleidoscope
cask scroll-reverser
cask sensiblesidebuttons
cask sketch
cask slack
cask spotify
cask vagrant
cask virtualbox
cask viscosity
cask visual-studio-code

brewlist=$(brew list)
install() {
    if [ -z "$(echo "$brewlist" | grep "\b${2:-$1}\b")" ]; then
        indent brew install "$1"
    fi
}

install "getantibody/antibody/antibody" antibody
install awscli
install chruby
install fzf
install git
install go
install jq
install macvim
install maven
install "neovim/neovim/neovim" neovim
install node
install "node@6"
install pstree
install redis
install ripgrep
install ruby
install "ruby@2.2"
install sqlite
install trash
install tree
install watchman
install yarn
install zsh

# install our fonts
echo
echo "Installing fonts"
indent cp -r "$XDG_CONFIG_HOME/fonts/*" "~/Library/Fonts"

# bootstrap dependencies
setopt extended_glob
for file in $XDG_CONFIG_HOME/**/bootstrap.sh~$XDG_CONFIG_HOME/bootstrap.sh; do
    echo
    echo "Bootsrapping $(basename $(dirname $file))"
    indent $file
done

# we're done with our functions now
unfunction cask
unfunction indent
unfunction install

echo
echo "Launching ZSH"
exec zsh

