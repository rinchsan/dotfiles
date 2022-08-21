#!/bin/bash

set -eu

brew bundle install --file=${HOME}/dotfiles/.Brewfile

gh release download --repo marcosnils/bin --pattern '*Darwin_x86*'
mv bin*Darwin_x86* bin
chmod +x bin
mv bin /usr/local/bin/bin
bin ensure

echo 'Changing default shell to fish'
echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"
