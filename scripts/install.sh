#!/bin/bash

cd $HOME

if ! type brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

if ! type git >/dev/null 2>&1; then
    brew install git
fi

if [ ! -d dotfiles ]; then
    git clone https://github.com/rinchsan/dotfiles.git
fi

cd dotfiles

make deploy

make init
