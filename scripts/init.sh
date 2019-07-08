#!/bin/bash

if ! type brew >/dev/null 2>&1; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# shell
brew install fish

# misc
brew install peco the_silver_searcher tree

# development
brew install pre-commit wget
brew install git gibo mysql
brew install node yarn
brew install awscli ansible
brew install goenv pyenv rbenv tfenv
