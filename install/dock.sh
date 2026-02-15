# Dark mode
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

# Configure the dock
defaults write com.apple.dock orientation -string "right"
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock tilesize -int 43

# Normal (non-natural) scroll direction
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

# Restart dock to apply changes
killall Dock
