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

echo 'Changing MacOS settings'
defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
defaults write -g AppleShowScrollBars -string "Always"
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g AppleShowAllExtensions -bool true

defaults write com.apple.PowerChime ChimeOnNoHardware -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1
defaults write com.apple.finder AppleShowAllFiles -bool YES
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool TRUE
defaults write com.apple.dock autohide -bool true
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 27 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 28 "<dict><key>enabled</key><false/></dic>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 29 "<dict><key>enabled</key><false/></dic>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 30 "<dict><key>enabled</key><false/></dic>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 31 "<dict><key>enabled</key><false/></dic>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 181 "<dict><key>enabled</key><false/></dic>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 182 "<dict><key>enabled</key><false/></dic>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 184 "<dict><key>enabled</key><false/></dic>"

networksetup -SetDNSServers Wi-Fi 8.8.8.8 8.8.4.4
networksetup -SetV6Off Wi-Fi

echo 'Rebooting to reflect settings'
sudo shutdownn -r now
