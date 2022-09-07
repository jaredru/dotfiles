# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
    source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

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

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

#
# Plugins
#

export ANTIBODY_HOME=$ZCACHEDIR/antibody

() {
    local antibody_plugins_txt=$ZDOTDIR/antibody/plugins.txt
    local antibody_plugins_sh=$ANTIBODY_HOME/plugins.sh
    local antibody_plugins_md5=$antibody_plugins_sh.md5

    if [[ ! -f $antibody_plugins_sh ]] || [[ ! -f $antibody_plugins_md5 ]] || ! md5sum --status --check $antibody_plugins_md5; then
        antibody bundle < $antibody_plugins_txt > $antibody_plugins_sh
        md5sum $antibody_plugins_txt $antibody_plugins_sh > $antibody_plugins_md5
    fi
    source $antibody_plugins_sh
}

ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=polka-handle-enter
ZSH_AUTOSUGGEST_USE_ASYNC=1

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

# better color switching
# https://wiki.archlinux.org/index.php/zsh#Colors
autoload -Uz colors && colors

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

