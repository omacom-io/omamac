#!/bin/zsh
set -euo pipefail

install() {
  clear
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

  section "Permission needed for setup..."
  sudo echo "✓ Granted"

  # Install all packages from Brew
  if ! command -v brew >/dev/null 2>&1; then
    section "Installing brew..."
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
    eval "$(/opt/homebrew/bin/brew shellenv zsh)"
    brew install git
  fi

  # Clone
  REPO="https://github.com/omacom-io/omamac.git"
  INSTALLER_DIR="$(mktemp -d)"
  trap 'rm -rf "$INSTALLER_DIR"' EXIT

  section "Cloning..."
  git clone --depth 1 "$REPO" "$INSTALLER_DIR"

  section "Installing packages..."
  packages=(tmux mise nvim opencode lazygit lazydocker starship zoxide eza jq gum gh libyaml)
  for pkg in $packages; do brew install "$pkg" || true; done

  # Install Alacritty manually from GitHub releases
  section "Installing Alacritty..."
  . "$INSTALLER_DIR/install/alacritty.sh"

  # Install Omadots
  curl -fsSL https://raw.githubusercontent.com/omacom-io/omadots/refs/heads/master/install.sh | zsh

  section "Configuring brew init..."
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$HOME/.config/shell/inits"
  echo "✓ Zsh"

  # Install secondary apps
  section "Installing apps..."
  casks=(rectangle-pro hammerspoon font-jetbrains-mono-nerd-font 1password docker-desktop google-chrome dropbox spotify signal whatsapp obsidian claude-code raycast zoom localsend tailscale)
  for cask in $casks; do brew install --cask "$cask" || true; done

  # Install basic dev envs
  section "Installing Ruby + Node..."
  mise use -g node
  mise use -g ruby

  # Omamac configs
  section "Configuring Mac..."
  mkdir -p "$HOME/.config"
  cp -Rf "$INSTALLER_DIR/config/"* "$HOME/.config/"

  # Create hush file to suppress "Last login" message
  touch "$HOME/.hushlogin"
  echo "✓ Hush login"

  . "$INSTALLER_DIR/install/mac.sh"
  echo "✓ Settings"

  defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"
  echo "✓ Hammerspoon"

  # Done!
  section "Finished!"
  echo "1. You must manually create the nine default workspaces with F3"
  echo "2. Manually disable all Keyboard Shortcuts for Windows + Spotlight + Mission Control"
  echo "3. Manually enable 'Switch to Desktop' Keyboard Shortcuts on CMD-[1-9]"
  echo "4. Manually import Rectangle Pro config from ~/.config/rectangle/RectangleProConfig.json (reveal hidden with Cmd + Shift + . in Finder)"
  echo "5. Manually import Raycast config from ~/.config/raycast/Raycast.rayconfig with pw: 12345678"
  echo "6. Remember to authenticate with: gh auth login"
  echo "7. Then logout and back in for everything to take effect (Cmd + Shift + Q)"

  open -a "Hammerspoon"
  open -a "Rectangle Pro"
  open -a "Raycast"
  open -a "Tailscale"
}

# Must use a function to prevent brew installs from stealing stdin
install
