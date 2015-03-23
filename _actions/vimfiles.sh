#!/bin/bash

[ -d ~/.vim ] && exit
cd
git clone git@github.com:nylen/vimfiles .vim
