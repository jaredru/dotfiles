
#
# Aliases
#

alias ls='ls -lG'

alias cart='carthage'

alias fnr='sed -i "" -E'

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

alias lsf='noglob recursive-find'

