
#
# Aliases
#

alias ls="ls -lG"
alias v="mvim"

#
# ..{%d}
#
# this is similar to an alias, so i'm putting it here...  typing "..3 " expands out
# to "cd ../../../".  typing "..5<CR>" expands out to "cd ../../../../..<CR>"
#

zmodload zsh/regex

try-expand-dots() {
    if [[ $BUFFER =~ "^\.\.([0-9]*)$" ]]; then
        BUFFER="cd ../"

        if [[ -n $match[1] ]]; then
            for ((i = 1; i < $match[1]; i++)); BUFFER+="../";
        fi

        zle end-of-line
        return 1
    fi

    return 0
}

try-expand-dots-for-space() {
    if try-expand-dots -eq 0; then
        zle self-insert
    fi
}

try-expand-dots-for-enter() {
    try-expand-dots
    zle accept-line
}

zle -N try-expand-dots-for-space
zle -N try-expand-dots-for-enter

bindkey " "  try-expand-dots-for-space
bindkey "^M" try-expand-dots-for-enter

