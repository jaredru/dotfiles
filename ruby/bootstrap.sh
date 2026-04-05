#!/usr/bin/env zsh
set -efu -o pipefail

local gemlist=$(gem list)
install() {
    if ! echo "$gemlist" | grep -q "^$1 "; then
        gem install "$1"
    fi
}

install cocoapods
install fastlane
install houston

gem update
gem cleanup
