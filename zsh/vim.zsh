
#
# Vim
#

KEYTIMEOUT=1

zle-line-init zle-keymap-select() {
    case $KEYMAP in
        vicmd)      printf "\033[2 q";;
        viins|main) printf "\033[6 q";;
    esac
}

zle -N zle-line-init
zle -N zle-keymap-select

