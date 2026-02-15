#!/bin/zsh

# Disable Mission Control keybindings to avoid conflicts with aerospace
# Log out and back in for changes to take effect

# Disable Mission Control (Ctrl+Up)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 32 '{ enabled = false; }'

# Disable Application windows (Ctrl+Down)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 33 '{ enabled = false; }'

# Disable Space left (Ctrl+Left)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 79 '{ enabled = false; }'

# Disable Space right (Ctrl+Right)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 80 '{ enabled = false; }'

# Disable window tiling shortcuts (introduced in macOS Sequoia)
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 300 '{ enabled = false; }' # Fill window
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 301 '{ enabled = false; }' # Center window
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 302 '{ enabled = false; }' # Move to left half
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 303 '{ enabled = false; }' # Move to right half
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 304 '{ enabled = false; }' # Move to previous display
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 305 '{ enabled = false; }' # Move to next display

# Disable Spotlight cmd-space shortcut
# ASCII 32 = space, keycode 49 = spacebar, modifier 1048576 = cmd
defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 64 '{ enabled = false; value = { parameters = (32, 49, 1048576); type = standard; }; }'

# Set cmd-1 through cmd-9 to switch to workspaces 1-9
# IDs 118-126 are "Switch to Desktop 1-9"
# Keycodes 18-26 are for keys 1-9
# ASCII codes 49-57 are for characters 1-9
# Modifier 1048576 is Command (cmd)
for i in {1..9}; do
  id=$((117 + i))
  keycode=$((17 + i))
  ascii=$((48 + i))
  defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add $id "{ enabled = true; value = { parameters = ($ascii, $keycode, 1048576); type = standard; }; }"
done

# Apply keyboard shortcut changes immediately
/System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u 2>/dev/null || true
