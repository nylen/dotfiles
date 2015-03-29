#!/bin/bash

_mocha=$(which _mocha)

if [ ! -r "$_mocha" ]; then
    # _mocha executable not present
    exit
fi

if head -n 5 "$_mocha" | grep -q Solarized; then
    # _mocha executable already patched
    exit
fi

# resolve any symlinks in path to _mocha - otherwise patch will change _mocha
# from a symlink to a regular file, and Node.js require will not work properly
while [ -L "$_mocha" ]; do
    pushd "$(dirname "$_mocha")" > /dev/null
    pushd "$(dirname "$(readlink "$_mocha")")" > /dev/null
    _mocha="$(pwd)/_mocha"
    popd > /dev/null
    popd > /dev/null
done

if [ ! -w "$_mocha" ]; then
    # cannot write to _mocha executable
    echo "WARNING: Failed to patch _mocha ($_mocha) - try this:"
    echo "  sudo $0"
    exit
fi

# This seems to be in flux between versions; _mocha may or may not have the #!
# header pointing it at node
if head -n 1 "$_mocha" | grep -q /usr/bin/env; then
    patch_file="mocha-env-node.diff"
else
    patch_file="mocha.diff"
fi

cd "$(dirname "$0")"
echo "$_mocha < $patch_file"
patch --directory "$(dirname "$_mocha")" --silent -p0 < "$patch_file"
