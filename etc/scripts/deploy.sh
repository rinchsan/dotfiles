#!/bin/bash

set -eu

DOTFILES=$(dirname "$(cd "$(dirname $0)" && pwd)")

cd ${DOTFILES}

for FILE in .??*
do
    [ "${FILE}" = ".git" ] && continue

    SRC=$(cd "$(dirname ${FILE})" && pwd)/$(basename ${FILE})
    ln -snfv ${SRC} ${HOME}/${FILE}
done

defaults write -g InitialKeyRepeat -int 12 # normal minimum is 15 (225 ms)
defaults write -g KeyRepeat -int 1 # normal minimum is 2 (30 ms)
defaults write com.apple.PowerChime ChimeOnNoHardware -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write -g AppleShowScrollBars -string "Always"
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
