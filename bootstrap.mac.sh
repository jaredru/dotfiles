#!/usr/bin/env zsh
set -efu -o pipefail

# ensure homebrew is installed
if ! command -v brew > /dev/null; then
    local brew_bin=/opt/homebrew/bin
    if [[ ! -x $brew_bin/brew ]]; then
        title "Installing homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    local homebrew_env=$($brew_bin/brew shellenv)
    eval "$homebrew_env"

    if [[ ! -e "$HOME/.zshrc" ]] || ! grep -Fxq "# Homebrew" "$HOME/.zshrc"; then
        cat <<EOF > "$HOME/.zshrc"

#
# Homebrew
#

$homebrew_env
EOF
    fi
fi


local casklist=$(brew list --cask)
cask() {
    if ! echo $casklist | grep -Fxq "${2:-$1}"; then
        HOMEBREW_NO_AUTO_UPDATE=1 brew install --cask "$1"
    fi
}

cask 1password
cask appcleaner
cask docker
cask google-chrome
#  cask hyperdock
cask imageoptim
cask itsycal
#  cask java
cask kaleidoscope
cask scroll-reverser
cask sensiblesidebuttons
cask slack
cask spotify
cask viscosity
cask visual-studio-code
cask zoom

local brewlist=$(brew list)
install() {
    if ! echo $brewlist | grep -Fxq "${2:-$1}"; then
        echo
        HOMEBREW_NO_AUTO_UPDATE=1 brew install "$1"
    fi
}

install antibody
install awscli
install bat
install chruby
install dust
install exa
install fd
install fzf
install git
install go
install jq
install macvim
install neovim
install node
install node@16
install openjdk && brew link openjdk --force
install pstree
install redis
install ripgrep
install ruby
install ruby@2.6
install sd
install trash
install tree
install yarn
install zsh

