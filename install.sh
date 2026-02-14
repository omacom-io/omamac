#!/bin/zsh
set -euo pipefail

echo
echo " ▄██████▄    ▄▄▄▄███▄▄▄▄      ▄████████   ▄▄▄▄███▄▄▄▄      ▄████████  ▄████████
███    ███ ▄██▀▀▀███▀▀▀██▄   ███    ███ ▄██▀▀▀███▀▀▀██▄   ███    ███ ███    ███
███    ███ ███   ███   ███   ███    ███ ███   ███   ███   ███    ███ ███    █▀ 
███    ███ ███   ███   ███   ███    ███ ███   ███   ███   ███    ███ ███       
███    ███ ███   ███   ███ ▀███████████ ███   ███   ███ ▀███████████ ███       
███    ███ ███   ███   ███   ███    ███ ███   ███   ███   ███    ███ ███    █▄ 
███    ███ ███   ███   ███   ███    ███ ███   ███   ███   ███    ███ ███    ███
 ▀██████▀   ▀█   ███   █▀    ███    █▀   ▀█   ███   █▀    ███    █▀  ████████▀ "


section() {
  echo -e "\n==> $1"
}

# Clone
REPO="https://github.com/omacom-io/omamac.git"
INSTALLER_DIR="$(mktemp -d)"
trap 'rm -rf "$INSTALLER_DIR"' EXIT

section "Cloning..."
git clone --depth 1 "$REPO" "$INSTALLER_DIR"

# Install all packages from Brew
if ! command -v brew >/dev/null 2>&1; then
  section "Installing brew..."
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | zsh
fi

section "Installing packages..."
brew bundle --file="$INSTALLER_DIR/Brewfile" || true

# Install Alacritty manually from GitHub releases
section "Installing Alacritty..."
. "$INSTALLER_DIR/install/alacritty.sh"

# Install basic dev envs
section "Installing Ruby + Node..."
mise use -g node
mise use -g ruby

# Install Omadots
curl -fsSL https://raw.githubusercontent.com/omacom-io/omadots/refs/heads/master/install.sh | zsh

section "Configuring brew init..."
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$HOME/.config/shell/inits"
echo "✓ Zsh"

# Omamac configs
section "Configuring Mac..."
mkdir -p "$HOME/.config"
cp -Rf "$INSTALLER_DIR/config/"* "$HOME/.config/"

. "$INSTALLER_DIR/install/hotkeys.sh"
echo "✓ Hotkeys"

. "$INSTALLER_DIR/install/dock.sh"
echo "✓ Dock"

defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"
echo "✓ Hammerspoon"

if [[ ! -f $HOME/Library/Preferences/com.knollsoft.Hookshot.plist ]]; then
  cp "$HOME/.config/rectangle/config.plist" "$HOME/Library/Preferences/com.knollsoft.Hookshot.plist"
  echo "✓ Rectangle Pro"
fi

if [[ ! -f $HOME/Library/Preferences/com.raycast.macos.plist ]]; then
  cp "$HOME/.config/raycast/config.plist" "$HOME/Library/Preferences/com.raycast.macos.plist"
  echo "✓ Raycast"
fi

# Interactive setup
if ! gh auth status &>/dev/null; then
  echo
  if gum confirm "Authenticate with GitHub?" </dev/tty; then
    gh auth login
  fi
fi

if ! tailscale status &>/dev/null; then
  echo
  if gum confirm "Connect to Tailscale network?" </dev/tty; then
    echo "This might take a minute..."
    sudo systemctl enable --now tailscaled.service
    sudo tailscale up --ssh --accept-routes
  fi
fi

# Done!
section "Finished!"
echo "Now logout and back in for everything to take effect (Cmd + Shift + Q)"
