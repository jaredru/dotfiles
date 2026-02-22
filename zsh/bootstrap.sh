#!/usr/bin/env zsh
set -efu -o pipefail

ZSH_PATH=$(whence zsh)
SHELLS_PATH="/etc/shells"

if ! grep -Fxq "$ZSH_PATH" "$SHELLS_PATH"; then
    #  title "Adding $ZSH_PATH to "$SHELLS_PATH"."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
fi

if [ "$SHELL" != "$ZSH_PATH" ]; then
    chsh -s "$ZSH_PATH"
fi

