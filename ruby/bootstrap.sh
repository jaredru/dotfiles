#!/usr/bin/env zsh
set -efu -o pipefail

# NOTE: chruby doesn't work with `set -u`. explicitly overriding here.
set +u

source ${0:a:h}/chruby.zsh
chruby 3

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

