#!/usr/bin/env zsh
set -efu -o pipefail

# system-level upgrades and cleanup
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
sudo apt-get -y install build-essential

# ensure homebrew is installed
if ! command -v brew > /dev/null; then
    local brew_bin=/home/linuxbrew/.linuxbrew/bin

    if [[ ! -x $brew_bin/brew ]]; then
        title "Installing homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    fi

    local homebrew_env=$($brew_bin/brew shellenv)
    eval "$homebrew_env"
fi

if [[ ! -e "$HOME/.zshrc" ]] || ! grep -Fxq "# Homebrew" "$HOME/.zshrc"; then
    cat <<EOF > "$HOME/.zshrc"

#
# Homebrew
#

$(brew shellenv)
EOF
fi

local brewlist=$(brew list)
install() {
    if ! echo $brewlist | grep -Fxq "${2:-$1}"; then
        echo
        HOMEBREW_NO_AUTO_UPDATE=1 brew install "$1"
    fi
}

install gcc

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
install tree
install yarn
install zsh

