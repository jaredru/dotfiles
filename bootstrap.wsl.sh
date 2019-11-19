#!/usr/bin/env zsh
set -efu -o pipefail

# system-level upgrades and cleanup
sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y autoremove
sudo apt-get -y install build-essential

# ensure homebrew is installed
if ! command -v brew > /dev/null; then
    title "Installing homebrew"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)"

    local homebrew_env=$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)
    eval "$homebrew_env"

    if ! grep -Fxq "# Homebrew" "$HOME/.zshrc"; then
        echo >> .zshrc
        echo "#" >> .zshrc
        echo "# Homebrew" >> .zshrc
        echo "#" >> .zshrc
        echo >> .zshrc
        echo "$homebrew_env" >> .zshrc
    fi

    brew install gcc
fi

local brewlist=$(brew list)
install() {
    if ! echo $brewlist | grep -Fxq "${2:-$1}"; then
        echo
        brew install "$1"
    fi
}

install antibody
install awscli
install chruby
install fzf
install git
install go
install jq
install neovim
install node
install node@10
install node@12
# install openjdk@8
install pstree
install redis
install ripgrep
install ruby@2.6
install tree
# install vagrant
# install virtualbox
install zsh

# add-ppa() {
#     if ! grep -q "^deb .*$1" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
#         sudo add-apt-repository "ppa:$1"
#     fi
# }

# add-ppa longsleep/golang-backports

# install() {
#     echo
#     sudo apt-get -y install "$1"
# }

# install awscli
# install fzf
# install git
# install golang-go
# install jq
# install neovim
# install openjdk-8-jdk-headless
# install python-neovim
# install ripgrep
# install tree
# install vagrant
# install virtualbox
# install zsh

# #
# # Docker
# #

# sudo apt-get -y remove docker docker-engine docker.io containerd runc
# sudo apt-get -y autoremove

# install apt-transport-https
# install ca-certificates
# install curl
# install gnupg-agent
# install software-properties-common

# curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
# sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# install docker-ce-cli

# # !! normal
# # sudo apt-get install -y docker-ce docker-ce-cli containerd.io
# # sudo gpasswd -a $USER docker

# # !! rootless
# # install cgroupfs-mount
# # install uidmap
# # curl -fsSL https://get.docker.com/rootless | sh

# #
# # Node
# #

# install-node() {
#     if [[ ! -f "$HOME/.nodes/node-$1/bin/node" ]]; then
#         mkdir -p "$HOME/.nodes"
#         wget -O "/tmp/node-$1.tar.xz" "https://nodejs.org/dist/$1/node-$1-linux-x64.tar.xz"
#         tar -xJvf "/tmp/node-$1.tar.xz" -C "$HOME/.nodes" --one-top-level="node-$1" --strip-components 1
#     fi
# }

# install-node v10.17.0
# install-node v12.13.0

# ln-node() {
#     for bin (node npm npx); do
#         if [[ -h /usr/local/bin/$bin ]]; then
#             sudo unlink /usr/local/bin/$bin
#         fi

#         sudo ln -s "$HOME/.nodes/node-$1/bin/$bin" /usr/local/bin/$bin
#     done
# }

# ln-node v12.13.0

# #
# # Ruby
# #

# if [[ ! -f /usr/local/bin/chruby-exec ]]; then
#     echo
#     mkdir -p /tmp/chruby
#     pushd /tmp/chruby
#     wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
#     tar -xzvf chruby-0.3.9.tar.gz
#     cd chruby-0.3.9/
#     sudo make install
#     popd
# fi

# if [[ ! -f /usr/local/bin/ruby-install ]]; then
#     echo
#     mkdir -p /tmp/ruby-install
#     pushd /tmp/ruby-install
#     wget -O ruby-install-0.7.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.7.0.tar.gz
#     tar -xzvf ruby-install-0.7.0.tar.gz
#     cd ruby-install-0.7.0/
#     sudo make install
#     popd
# fi

# ruby-install -c --no-reinstall ruby 2.6

# #
# # Zsh
# #

# if ! command -v antibody > /dev/null; then
#     title "Installing antibody"
#     curl -sfL git.io/antibody | sudo sh -s - -b /usr/local/bin
# fi

# # install maven
# # install sqlite
# # install watchman

