
export PATH="$PATH:$(npm -g prefix)/bin"
source $(whence chnode)

(){
    setopt local_options nullglob
    export NODES=(
        $HOMEBREW_CELLAR/node/*
        $HOMEBREW_CELLAR/node@*/*
    )
}
