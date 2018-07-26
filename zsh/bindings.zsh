
#
# Bindings
#
# <C-V> followed by key sequence to get the value for bindkey
#

# add missing vim hotkeys
# fixes backspace deletion issues
# http://zshwiki.org/home/zle/vi-mode
# -a is same as -M vicmd
bindkey -a u undo
bindkey -a U redo
bindkey '^?' backward-delete-char
bindkey '^H' backward-delete-char

# home and end should do something useful
bindkey "^A" beginning-of-line
bindkey "^E" end-of-line

# option+left/right should jump by word
bindkey "\eb" backward-word
bindkey "\ef" forward-word

# F8 and ctrl+space to history completion
bindkey "\e[19~" history-beginning-search-backward
bindkey "^@"     history-beginning-search-backward

# delete should not insert a tilde
bindkey "\e[3~" delete-char

