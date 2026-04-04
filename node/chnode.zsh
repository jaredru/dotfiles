
if command -v chnode &>/dev/null; then
    source $(whence chnode)

    if [[ -n "$HOMEBREW_CELLAR" ]]; then
        (){
            setopt local_options nullglob
            export NODES=(
                $HOMEBREW_CELLAR/node/*
                $HOMEBREW_CELLAR/node@*/*
            )
        }
    fi
fi
