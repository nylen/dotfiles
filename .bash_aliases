#!/bin/bash

# Most Linuxes source this file if it exists, so use it to load other custom
# shell configs.

if [ -f ~/.bashrc_nylen_dotfiles ]; then
    . ~/.bashrc_nylen_dotfiles
fi
# Old .bashrc_nylen_dotfiles
if [ -f ~/.bashrc_custom ]; then
    . ~/.bashrc_custom
fi
# System-specific configuration
if [ -f ~/.bashrc_local ]; then
    . ~/.bashrc_local
fi
if [ -f ~/.bash_aliases_linux ]; then
    . ~/.bash_aliases_linux
fi

# Run hook functions on shell init - needs to come after .bashrc_local
__run_hooks chpwd "$__last_wd" ""

# Directory commands
alias -- -="cd -"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias md="mkdir"
alias mcd="mkdir-cd"
alias d="__cd_path_alias"

# Miscellaneous
alias ping="ping -c 4"
alias lc="ls --color=always"
alias less="less -R"
alias di="di -I ext3,ext4"

# System management
alias etc="sudo etckeeper vcs"
alias svc="sudo service"

# hub is a nice wrapper around git that handles lots of GitHub stuff including
# auth.  Installing Go is a pain on ARM systems though, so only use it if it's
# already available.
if type -P hub > /dev/null; then
    alias git="hub"
fi

# ag is many times faster than ack
if type -P ag > /dev/null; then
    alias ack="ag"
elif ! type -P ack > /dev/null; then
    # poor man's ack
    alias ack="git ls-files -z | xargs -0 grep -P"
fi

# more predictable search aliases
alias g="git ls-files -z | xargs -0 grep -P"
alias f="find . -type f | sort -z | xargs -0 grep -P"
alias fphp="find . -type f -name '*.php' | sort -z | xargs -0 grep -P"
