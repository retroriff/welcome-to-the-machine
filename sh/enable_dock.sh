#!/bin/bash
defaults write com.apple.dock autohide -bool false
defaults delete com.apple.dock autohide-delay
defaults write com.apple.dock no-bouncing -bool FALSE

killall Dock
