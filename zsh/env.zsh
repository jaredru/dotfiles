
#
# Environment
#

export EDITOR=mvim
export REACT_EDITOR=code

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

if [[ -d "$HOME/bin" ]]; then
    export PATH="$HOME/bin:$PATH"
fi

#
# Android
#

export ANDROID_HOME=~/code/android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

#
# Go
#

export GOPATH=~/code/go
#  export PATH=$PATH:$GOPATH/bin

#
# Java
#

if command -v java_home > /dev/null; then
    export JAVA_HOME=$(command java_home -v 1.8)
else
    export JAVA_HOME=$(dirname $(dirname $(readlink -e $(command -v javac))))
fi

#
# Node
#

chnode 10 > /dev/null

#
# Ruby
#

chruby 2.6 > /dev/null

