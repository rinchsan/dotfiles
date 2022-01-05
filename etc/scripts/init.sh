#!/bin/bash

set -eu

brew bundle install --file=~/dotfiles/.Brewfile

echo 'Changing default shell to fish'
echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"

echo 'Changing key repeat settings'
defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
