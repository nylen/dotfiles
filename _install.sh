#!/bin/bash

cd "$(dirname "$0")"

install_dotfiles() {
    for i in * .*; do
        case "$i" in
            .|..|.git|.gitignore|_*|*.md|\*)
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

install_dotfiles

os="$(uname -s)"

case "$os" in
    Darwin)
        cd _osx
        install_dotfiles
        ;;
    Linux)
        cd _linux
        install_dotfiles
        ;;
esac

# Go home and check for broken symlinks
cd

deleted_files=()
deleted_files+=(".bashrc_custom")

for i in "${deleted_files[@]}"; do
    if [ -L "$i" ] && ! [ -f "$i" ]; then
        echo "Deleting broken symlink: $i"
        rm "$i"
    fi
done
