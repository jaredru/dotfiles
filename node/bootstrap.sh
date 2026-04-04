#!/usr/bin/env zsh
set -efu -o pipefail

if ! command -v npm &>/dev/null; then
    echo "npm not found, skipping node bootstrap"
    exit 0
fi

npm -g update
npm -g install chnode@steakknife/chnode
