
#
# Environment
#

export EDITOR=mvim
export REACT_EDITOR=code

export HOMEBREW_CASK_OPTS="--appdir=/Applications"

#
# Node
#

chnode 10 > /dev/null

#
# Ruby
#

chruby 2.3 > /dev/null

#
# Go
#

export GOPATH=~/code/go
#  export PATH=$PATH:$GOPATH/bin

#
# Java
#

export JAVA_HOME=$(/usr/libexec/java_home -v 1.8)

#
# Android
#

export ANDROID_HOME=~/code/android/sdk
export PATH=$PATH:$ANDROID_HOME/platform-tools

