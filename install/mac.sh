#!/bin/zsh

# Disable Mission Control keybindings to avoid conflicts with aerospace
# Log out and back in for changes to take effect

# Hammerspoon config
defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"

# Disable Mission Control (Ctrl+Up)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 '{ enabled = 0; }'

# Disable Application windows (Ctrl+Down)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 '{ enabled = 0; }'

# Disable Space left (Ctrl+Left)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 '{ enabled = 0; }'

# Disable Space right (Ctrl+Right)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 '{ enabled = 0; }'

# Disable window tiling shortcuts (introduced in macOS Sequoia)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 300 '{ enabled = 0; }' # Fill window
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 301 '{ enabled = 0; }' # Center window
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 302 '{ enabled = 0; }' # Move to left half
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 303 '{ enabled = 0; }' # Move to right half
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 304 '{ enabled = 0; }' # Move to previous display
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 305 '{ enabled = 0; }' # Move to next display

# Set dock position to right
defaults write com.apple.dock orientation -string "right"

# Enable autohide
defaults write com.apple.dock autohide -bool true

# Set dock size to 43
defaults write com.apple.dock tilesize -int 43

# Restart dock to apply changes
killall Dock
