#!/usr/bin/env zsh
set -efu -o pipefail

title "Installing fonts"
cp -r $XDG_CONFIG_HOME/fonts/*.{o,t}tf $HOME/Library/Fonts

