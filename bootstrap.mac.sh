#!/usr/bin/env zsh
set -efu -o pipefail

# ensure homebrew is installed
if ! command -v brew > /dev/null; then
    title "Installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install brew packages
casklist=$(brew cask list)
cask() {
    if [ -z "$(echo "$casklist" | grep "\b${2:-$1}\b")" ]; then
        brew cask install "$1"
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
        brew install "$1"
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
install "node@16"
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

