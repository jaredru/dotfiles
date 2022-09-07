
#
# Aliases
#

[[ -n $commands[bat] ]] &&
    alias cat='bat --paging=never'

[[ -n $commands[perl] ]] &&
    alias fnr='perl -i -pe'

# alias ls='ls -lG'
[[ -n $commands[exa] ]] &&
    alias ls='exa -l'

[[ -n $commands[rg] ]] &&
    alias rg='rg -S'

[[ -n $commands[trash] ]] &&
    alias rmt='trash'

[[ -n $commands[nvim] ]] &&
    alias vim='nvim'

#
# Funcs
#

hist() { print -z $(fc -ln 1 | fzf --tac --tiebreak=index -q "$*") }

psgrep() { ps up $(pgrep -f "$*") 2>&-; }

