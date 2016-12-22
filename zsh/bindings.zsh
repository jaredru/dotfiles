
#
# Bindings
#
# <C-V> followed by key sequence to get the value for bindkey
#

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

