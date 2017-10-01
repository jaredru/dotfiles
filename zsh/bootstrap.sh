#!/usr/bin/env zsh
set -efu -o pipefail

ZSH_PATH="/usr/local/bin/zsh"
SHELLS_PATH="/etc/shells"

if ! grep -Fxq "$ZSH_PATH" "$SHELLS_PATH"; then
    echo "Adding $ZSH_PATH to "$SHELLS_PATH"; your password may be necessary."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells > /dev/null
fi

if [ "$SHELL" != "$ZSH_PATH" ]; then
    chsh -s "$ZSH_PATH"
fi

