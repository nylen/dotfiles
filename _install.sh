#!/bin/bash

cd "$(dirname "$0")"

install_dotfiles() {
    dst_path="$1"
    [ -z "$dst_path" ] && dst_path="$HOME"
    mkdir -pv "$dst_path"

    for i in * .*; do
        case "$i" in
            .|..|.git|.gitignore|bin|test|_*|*.md|\*)
                ;;
            *)
                src="$(pwd)/$i"
                dst="$dst_path/$i"
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
        pushd _osx > /dev/null
            install_dotfiles
        popd > /dev/null
        ;;
    Linux)
        pushd _linux > /dev/null
            install_dotfiles
        popd > /dev/null
        ;;
esac

pushd bin > /dev/null
    install_dotfiles "$HOME/bin"
popd > /dev/null

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
