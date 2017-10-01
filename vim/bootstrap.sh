#!/usr/bin/env zsh
set -efu -o pipefail

piplist=$(pip2 list --format=legacy)
install() {
    if [ -z "$(echo "$piplist" | grep "^$1 ")" ]; then
        pip2 install "$1"
    fi
}

install neovim

nvim --cmd "let g:bootstrap=1" &> /dev/null

