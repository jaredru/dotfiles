
#
# Aliases
#

alias cart='carthage'

alias fnr='perl -i -pe'

alias ls='ls -lG'

alias lsf='noglob recursive-find'

alias rg='rg -S'

alias rmt='trash'

alias vim='nvim'

psgrep() { ps up $(pgrep -f $@) 2>&-; }

recursive-find() {
    setopt local_options
    setopt extended_glob
    setopt glob_dots

    # \       - ignores aliases
    # (#l)    - lower case characters also match upper case
    # ${var}  - injects a variable
    # ${~var} - allows globbing and file expansion on the variable
    \ls -1dG **/(#l)${~*}
}

