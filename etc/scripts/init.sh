#!/bin/bash

set -eu

sudo softwareupdate --install-rosetta
brew bundle install --file="${HOME}"/dotfiles/.Brewfile

gh auth login
gh release download --repo marcosnils/bin --pattern '*Darwin_arm64'
mv bin*Darwin_arm64 bin
chmod +x bin
sudo mv bin /opt/homebrew/bin/bin
bin ensure

echo 'Changing default shell to fish'
which fish | sudo tee -a /etc/shells
chsh -s "$(which fish)"

echo 'Changing MacOS settings'
defaults write -g InitialKeyRepeat -int 12
defaults write -g KeyRepeat -int 1
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
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 28 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 29 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 30 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 31 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 181 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 182 "<dict><key>enabled</key><false/></dict>"
defaults write com.apple.symbolichotkeys.plist AppleSymbolicHotKeys -dict-add 184 "<dict><key>enabled</key><false/></dict>"

networksetup -SetDNSServers Wi-Fi 1.1.1.1 1.0.0.1
networksetup -SetV6Off Wi-Fi

echo 'Rebooting to reflect settings'
sudo shutdown -r now
