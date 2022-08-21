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

defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
defaults write com.apple.PowerChime ChimeOnNoHardware -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write -g AppleShowScrollBars -string "Always"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.TextEdit RichText -int 0
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
networksetup -setdnsservers Wi-Fi 2001:4860:4860::8844 2001:4860:4860::8888 8.8.4.4 8.8.8.8
defaults write com.apple.finder AppleShowAllFiles -bool YES
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
defaults write com.apple.dock autohide -bool true

sudo shutdownn -r now
