
#
# Environment
#

export EDITOR=mvim
export REACT_EDITOR=code

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

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
    if [[ -d "/home/linuxbrew/.linuxbrew/opt/openjdk@11" ]]; then
        export PATH="/home/linuxbrew/.linuxbrew/opt/openjdk@11/bin:$PATH"
    fi
    export JAVA_HOME=$(dirname $(dirname $(readlink -f $(command -v javac))))
fi

#
# Node
#

chnode 16 > /dev/null

#
# Ruby
#

chruby 2 > /dev/null

