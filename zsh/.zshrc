#
# Local
#

# source a local zshrc for private/untracked stuff
[[ -a "$HOME/.zshrc" ]] && source "$HOME/.zshrc"

#
# Config
#

# vi mode
# do this first to ensure all subsequent bindings apply to this mode
bindkey -v

# enable advanced glob features
setopt extended_glob

#
# Prompt
#

export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml
eval "$(starship init zsh)"

#
# Plugins
#

export ANTIDOTE_HOME=$ZCACHEDIR/antidote
mkdir -p $ANTIDOTE_HOME

() {
    local plugins_txt=$ZDOTDIR/antidote/plugins.txt
    local plugins_sh=$ANTIDOTE_HOME/plugins.sh
    local plugins_md5=$plugins_sh.md5

    if [[ ! -f $plugins_sh ]] || [[ ! -f $plugins_md5 ]] || ! md5sum --status --check $plugins_md5; then
        fpath=($(brew --prefix antidote)/share/antidote/functions $fpath)
        autoload -Uz antidote

        antidote bundle < $plugins_txt > $plugins_sh

        local md5_digest=$(openssl md5 -r $plugins_txt $plugins_sh)
        echo "$md5_digest" > $plugins_md5
    fi
    source $plugins_sh
}

ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=polka-handle-enter
ZSH_AUTOSUGGEST_USE_ASYNC=1

# activate mise (version manager for node, ruby, etc.)
eval "$(mise activate zsh)"

# source all .zsh files in our config path
for file in $XDG_CONFIG_HOME/**/*.zsh; do
    source $file
done

#
# Profile
#

# it'd be nice if there was a way to close around this.
# i don't honestly need it set forever.
profile=$0

profile-edit() {
    $EDITOR $profile
}

profile-reload() {
    source $profile
}

alias profile="profile-edit"
alias reload="profile-reload"

#
# Options
#

# save command history
# save 100k commands total
# save 100k commands per session
HISTFILE=$ZCACHEDIR/history
SAVEHIST=100000
HISTSIZE=100000

# remove older dupes from history
# remove extra blanks from each history item
# write to $HISTFILE on demand instead of on exit
# read to and write from $HISTFILE on demand instead of on exit
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt inc_append_history
setopt share_history

# better tab completion support
autoload -Uz compinit && compinit -d $ZCACHEDIR/compdump

# be case insensitive
# i need to read into this more, but the second bit (r:...) matches within filenames as well
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# use an interactive menu
zstyle ":completion:*" menu select

# complete the first result by default
setopt menu_complete

# <S-TAB> goes backwards
bindkey "\e[Z" reverse-menu-complete

