
source /usr/local/opt/chruby/share/chruby/chruby.sh
source /usr/local/opt/chruby/share/chruby/auto.sh

local cellar=$(brew --cellar)
export RUBIES=(
    $cellar/ruby/*
    $cellar/ruby@*/*
)

