#!/bin/bash

cd "$(dirname "$0")"

install_dotfiles() {
    for i in * .*; do
        case "$i" in
            .|..|.git|_*|*.md)
                ;;
            *)
                src="$(pwd)/$i"
                dst=~/"$i"
                if [ ! -L "$dst" ]; then
                    ln -vs "$src" "$dst"
                fi
                ;;
        esac
    done

    if [ -d _actions ]; then
        for i in _actions/*.sh; do
            "$i"
        done
    fi
}

os="$(uname -s)"

case "$os" in
    Darwin)
        cd _osx
        install_dotfiles
        ;;
esac
