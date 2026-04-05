
#
# Aliases
#

[[ -n $commands[bat] ]] &&
    alias cat='bat --paging=never'

[[ -n $commands[perl] ]] &&
    alias fnr='perl -i -pe'

# alias ls='ls -lG'
[[ -n $commands[eza] ]] &&
    alias ls='eza -l'

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

brew-deps() {
    brew info --json=v2 --installed | bun -e "
        const {formulae} = await Bun.file('/dev/stdin').json();
        const u = Object.fromEntries(formulae.map(f => [f.name, []]));
        for (const f of formulae)
            for (const d of f.installed[0]?.runtime_dependencies ?? [])
                u[d.full_name]?.push(f.name);
        for (const n of Object.keys(u).sort())
            console.log('\x1b[1;34m%s ->\x1b[0m %s', n, u[n].join(' '));
    "
}

