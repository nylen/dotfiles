#!/bin/sh

profile="$(defaults read 'com.apple.Terminal' 'Default Window Settings')"

if [ "$profile" = "solarized-dark" ]; then
    exit
fi

cd "$(dirname "$0")"
open solarized-dark.terminal
defaults write 'com.apple.Terminal' 'Default Window Settings' -string 'solarized-dark'
defaults write 'com.apple.Terminal' 'Startup Window Settings' -string 'solarized-dark'
echo 'Set default Terminal.app profile to solarized-dark; restart Terminal.app'
