#!/bin/bash

cd $HOME

if ! type brew >/dev/null 2>&1; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

if ! type git >/dev/null 2>&1; then
    brew install git
fi

if [ ! -d dotfiles ]; then
    git clone git@github.com:snowman-mh/dotfiles.git
fi

cd dotfiles

make deploy

make init
