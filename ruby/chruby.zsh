
local share="$HOMEBREW_PREFIX/share/chruby"

source "$share/chruby.sh"
source "$share/auto.sh"

(){
    setopt local_options nullglob
    export RUBIES=(
        $HOMEBREW_CELLAR/ruby/*
        $HOMEBREW_CELLAR/ruby@*/*
    )
}

