#!/bin/bash

if ! type brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

# misc
brew install ghq peco the_silver_searcher tree jq gnu-sed

# development
brew install pre-commit wget
brew install git gibo mysql
brew install node yarn
brew install awscli ansible
brew install goenv pyenv rbenv tfenv
brew install go

# fish
brew install fish
echo 'Changing default shell to fish'
echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"
