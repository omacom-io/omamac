# Configure the dock
defaults write com.apple.dock orientation -string "right"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 43

# Restart dock to apply changes
killall Dock
