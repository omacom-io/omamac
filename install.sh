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

  login_item() {
    osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"/Applications/$1.app\", hidden:false}" 2>/dev/null
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
  packages=(tmux mise opencode lazygit lazydocker starship zoxide eza jq gum gh tailscale)
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
  casks=(rectangle-pro hammerspoon font-jetbrains-mono-nerd-font 1password docker-desktop google-chrome dropbox spotify signal whatsapp obsidian claude-code raycast zoom)
  for cask in $casks; do brew install --cask "$cask" || true; done

  # Install basic dev envs
  section "Installing Ruby + Node..."
  mise use -g node
  mise use -g ruby

  # Omamac configs
  section "Configuring Mac..."
  mkdir -p "$HOME/.config"
  cp -Rf "$INSTALLER_DIR/config/"* "$HOME/.config/"

  . "$INSTALLER_DIR/install/hotkeys.sh"
  echo "✓ Hotkeys"

  . "$INSTALLER_DIR/install/dock.sh"
  echo "✓ Dock"

  defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"
  login_item Hammerspoon
  echo "✓ Hammerspoon"

  if [[ ! -f $HOME/Library/Preferences/com.knollsoft.Hookshot.plist ]]; then
    cp "$HOME/.config/rectangle/config.plist" "$HOME/Library/Preferences/com.knollsoft.Hookshot.plist"
    login_item Hookshot
  fi
  echo "✓ Rectangle Pro"

  if [[ ! -f $HOME/Library/Preferences/com.raycast.macos.plist ]]; then
    cp "$HOME/.config/raycast/config.plist" "$HOME/Library/Preferences/com.raycast.macos.plist"
    login_item Raycast
  fi
  echo "✓ Raycast"

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
      sudo tailscale up --ssh --accept-routes
    fi
  fi

  # Done!
  section "Finished!"
  echo "You must manually create the nine default workspaces with F3"
  echo "Then logout and back in for everything to take effect (Cmd + Shift + Q)"
}

# Must use a function to prevent brew installs from stealing stdin
install
