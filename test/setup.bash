#!/bin/bash

cd "$(dirname "$BASH_SOURCE")"
cd ..
. .bashrc_nylen_dotfiles

debug() {
    printf "$@" | sed '1s/^/# /; 2,$s/^/#>/' >&3
}
