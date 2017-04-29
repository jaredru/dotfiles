#!/usr/bin/env zsh

# set our default xdg config path, but only if it's not already set
[[ -z $XDG_CONFIG_HOME ]] && export XDG_CONFIG_HOME="$HOME/.config"
[[ -z $XDG_CACHE_HOME ]]  && export XDG_CACHE_HOME="$HOME/.cache"

# a simple function to indent a command's output
indent() {
    eval $@ |& sed 's/^/  /'
}

# check if our config directory contains our dotfiles repo
if [[ -d $XDG_CONFIG_HOME/.git ]]; then
    # make sure it's up to date
    echo "Updating dotfiles repo in $XDG_CONFIG_HOME"
    pushd $XDG_CONFIG_HOME
    indent git pull
    indent git submodule update --init --recursive
    popd
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

    if [[ ! -f $home_file ]]; then
        ln -s $file $home_file
    else
        indent echo "File '$home_file' already exists."
    fi
done

# ensure homebrew is installed
if ! command -v brew > /dev/null; then
    echo "Installing homebrew"
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# install brew packages
install() {
    if [ ! -f "/usr/local/bin/${2:-$1}" ]; then
        brew install "$1"
    fi
}

install "getantibody/antibody/antibody" antibody
install awscli aws
install chruby chruby-exec
install fzf
install git
install go
install jq
install maven mvn
install "neovim/neovim/neovim" nvim
install node
install "node@6" node6
install pstree
install redis redis-cli
install ripgrep rg
install ruby
install "ruby@2.2" ruby22
install sqlite sqlite3
install trash
install tree
install watchman
install yarn
install zsh

# install our fonts
cp -r fonts/* ~/Library/Fonts

# bootstrap dependencies
for file in $XDG_CONFIG_HOME/**/bootstrap.sh~$XDG_CONFIG_HOME/bootstrap.sh; do
    $file
done

# we're done with our functions now
unfunction install
unfunction indent

echo
echo "Launching ZSH"
exec zsh

