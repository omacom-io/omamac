#!/bin/bash

# Configure macOS Dock settings
# Restart dock to apply changes

# Set dock position to right
defaults write com.apple.dock orientation -string "right"

# Enable autohide
defaults write com.apple.dock autohide -bool true

# Set dock size to 43
defaults write com.apple.dock tilesize -int 43

# Restart dock to apply changes
killall Dock

echo "Dock configured: positioned on right with autohide enabled"
