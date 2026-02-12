#!/bin/zsh

# Disable Mission Control keybindings to avoid conflicts with aerospace
# Log out and back in for changes to take effect

# Disable Mission Control (Ctrl+Up)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 '{ enabled = 0; }'

# Disable Application windows (Ctrl+Down)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 '{ enabled = 0; }'

# Disable Space left (Ctrl+Left)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 '{ enabled = 0; }'

# Disable Space right (Ctrl+Right)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 '{ enabled = 0; }'

# Disable Switch to Desktop 1-4 (Ctrl+1,2,3,4)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 118 '{ enabled = 0; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 119 '{ enabled = 0; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 120 '{ enabled = 0; }'
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 121 '{ enabled = 0; }'

# Disable window tiling shortcuts (introduced in macOS Sequoia)
# These use the Globe key and conflict with aerospace
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 300 '{ enabled = 0; }' # Fill window
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 301 '{ enabled = 0; }' # Center window
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 302 '{ enabled = 0; }' # Move to left half
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 303 '{ enabled = 0; }' # Move to right half
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 304 '{ enabled = 0; }' # Move to previous display
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 305 '{ enabled = 0; }' # Move to next display

# Disable application window shortcuts globally
# These require restarting apps or logging out to take effect
defaults write -g NSUserKeyEquivalents -dict-add 'Minimize' '\0'
defaults write -g NSUserKeyEquivalents -dict-add 'Minimize All' '\0'
defaults write -g NSUserKeyEquivalents -dict-add 'Hide' '\0'
defaults write -g NSUserKeyEquivalents -dict-add 'Hide Others' '\0'
defaults write -g NSUserKeyEquivalents -dict-add 'Zoom' '\0'
