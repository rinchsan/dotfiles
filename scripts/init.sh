#!/bin/bash

if ! type brew >/dev/null 2>&1; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# misc
brew install ghq peco the_silver_searcher tree jq gnu-sed

# development
brew install pre-commit wget
brew install git gibo mysql
brew install node yarn
brew install awscli ansible
brew install goenv pyenv rbenv tfenv

# fish
brew install fish
echo 'Changing default shell to fish'
echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"
