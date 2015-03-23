#!/bin/bash

cd "$(dirname "$0")"

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
