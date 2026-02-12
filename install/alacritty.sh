#!/bin/bash

# Install Alacritty manually from GitHub releases (deprecated on homebrew due to unsigned binaries)

if [[ ! -d "/Applications/Alacritty.app" ]]; then
  echo "Downloading latest Alacritty from GitHub releases..."
  ALACRITTY_URL=$(curl -s https://api.github.com/repos/alacritty/alacritty/releases/latest | grep -o '"browser_download_url": "[^"]*\.dmg"' | cut -d'"' -f4)
  curl -LO "$ALACRITTY_URL"
  ALACRITTY_DMG=$(basename "$ALACRITTY_URL")
  hdiutil attach "$ALACRITTY_DMG"
  cp -R /Volumes/Alacritty/Alacritty.app /Applications/
  hdiutil detach /Volumes/Alacritty
  rm "$ALACRITTY_DMG"
fi
