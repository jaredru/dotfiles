#!/usr/bin/env zsh
set -efu -o pipefail

for font in $XDG_CONFIG_HOME/fonts/*.{o,t}tf; do
    if [[ ! -f /mnt/c/Windows/Fonts/$(basename $font) ]]; then
        read -s -k '?Fonts must be installed manually. [Press any key to continue]'
        echo

        # explorer always returns a failing exit code.
        # `!` prevents "set -e" from exiting.
        ! explorer.exe 'C:\Windows\Fonts'

        pushd $XDG_CONFIG_HOME/fonts
        ! explorer.exe .
        popd

        break
    fi
done

if [[ -f /etc/fonts/local.conf ]]; then
    if ! grep -Fq /mnt/c/Windows/Fonts /etc/fonts/local.conf; then
        sudo sed -i '\#</fontconfig>#i\ \ \ \ <dir>/mnt/c/Windows/Fonts</dir>' /etc/fonts/local.conf
    fi
else
    sudo tee -a /etc/fonts/local.conf <<EOF > /dev/null
<?xml version="1.0"?>
<!DOCTYPE fontconfig SYSTEM "fonts.dtd">
<fontconfig>
    <dir>/mnt/c/Windows/Fonts</dir>
</fontconfig>
EOF
fi

