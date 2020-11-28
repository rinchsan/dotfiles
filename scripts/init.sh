#!/bin/bash

set -eu

brew bundle --global

echo 'Changing default shell to fish'
echo "$(which fish)" | sudo tee -a /etc/shells
chsh -s "$(which fish)"
