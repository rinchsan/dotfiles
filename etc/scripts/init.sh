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

echo 'Changing key repeat settings'
defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
defaults write com.apple.PowerChime ChimeOnNoHardware -bool true;killall PowerChime
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
