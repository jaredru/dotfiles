
#
# Aliases
#

alias cart='carthage'

alias fnr='perl -i -pe'

alias ls='ls -lG'

alias rg='rg -S'

alias rmt='trash'

alias vim='nvim'

#
# Funcs
#

hist() { print -z $(fc -ln 1 | fzf --tac --tiebreak=index -q "$*") }

psgrep() { ps up $(pgrep -f "$*") 2>&-; }

