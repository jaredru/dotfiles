
if [[ -n "$HOMEBREW_PREFIX" ]] && [[ -d "$HOMEBREW_PREFIX/share/chruby" ]]; then
    source "$HOMEBREW_PREFIX/share/chruby/chruby.sh"
    source "$HOMEBREW_PREFIX/share/chruby/auto.sh"

    (){
        setopt local_options nullglob
        export RUBIES=(
            $HOMEBREW_CELLAR/ruby/*
            $HOMEBREW_CELLAR/ruby@*/*
        )
    }
fi
