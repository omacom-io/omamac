#!/usr/bin/env bash
set -euo pipefail

echo
echo -e " ▄██████▄    ▄▄▄▄███▄▄▄▄      ▄████████   ▄▄▄▄███▄▄▄▄      ▄████████  ▄████████
███    ███ ▄██▀▀▀███▀▀▀██▄   ███    ███ ▄██▀▀▀███▀▀▀██▄   ███    ███ ███    ███
███    ███ ███   ███   ███   ███    ███ ███   ███   ███   ███    ███ ███    █▀ 
███    ███ ███   ███   ███   ███    ███ ███   ███   ███   ███    ███ ███       
███    ███ ███   ███   ███ ▀███████████ ███   ███   ███ ▀███████████ ███       
███    ███ ███   ███   ███   ███    ███ ███   ███   ███   ███    ███ ███    █▄ 
███    ███ ███   ███   ███   ███    ███ ███   ███   ███   ███    ███ ███    ███
 ▀██████▀   ▀█   ███   █▀    ███    █▀   ▀█   ███   █▀    ███    █▀  ████████▀ "

download() {
  local url="https://raw.githubusercontent.com/omacom-io/omamac/master/$1"
  if ! curl -fsSL "$url"; then
    echo "Failed to download: $1" >&2
    exit 1
  fi
}

rexec() {
  download $1 | bash
}

section() {
  echo
  echo "==> $1"
  echo
}

brew_install() {
  for pkg in "$@"; do
    brew install "$pkg" || true
  done
}

brew_cask_install() {
  for pkg in "$@"; do
    brew install --cask "$pkg" || true
  done
}

if ! command -v brew >/dev/null 2>&1; then
  section "Installing brew..."
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash
fi

# Change from zsh to bash
section "Installing bash..."
brew install bash

# Install basic tools
section "Installing core packages..."
brew_install aerospace tmux mise opencode lazygit starship zoxide eza jq gum font-jetbrains-mono-nerd-font

# Install Alacritty manually from GitHub releases
section "Installing Alacritty..."
rexec install/alacritty.sh

# Install basic dev envs
section "Installing mise envs..."
mise settings ruby.compile=false
mise use -g ruby
mise use -g node

# Configure git
if [[ ! -f $HOME/.config/git/config ]]; then
  section "Configuring git..."

  GIT_NAME=$(gum input --placeholder "Your full name" --prompt "Git name: " </dev/tty)
  GIT_EMAIL=$(gum input --placeholder "your@email.com" --prompt "Git email: " </dev/tty)

  download config/git.conf | sed "s/{{GIT_NAME}}/${GIT_NAME}/g; s/{{GIT_EMAIL}}/${GIT_EMAIL}/g" >"$HOME/.config/git/config"
fi

# Copy configs
section "Configuring tools..."
mkdir -p "$HOME/.config/"
download config/bashrc >"$HOME/.bashrc"
echo "✓ Bash"

mkdir -p "$HOME/.config/aerospace"
download config/aerospace.toml >"$HOME/.config/aerospace/aerospace.toml"
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/AeroSpace.app", hidden:false}' 2>/dev/null || true
echo "✓ Aerospace"

mkdir -p "$HOME/.config/alacritty"
download config/alacritty.toml >"$HOME/.config/alacritty/alacritty.toml"
echo "✓ Alacritty"

download config/starship.toml >"$HOME/.config/starship.toml"
echo "✓ Starship"

mkdir -p "$HOME/.config/tmux"
download config/tmux.conf >"$HOME/.config/tmux/tmux.conf"
echo "✓ Tmux"

rexec config/macos/dock.sh
rexec config/macos/hotkeys.sh
echo "✓ macOS"

# Install GUI applications via cask
section "Install extra packages"
brew_cask_install 1password docker google-chrome dropbox spotify signal whatsapp obsidian claude-code raycast
brew_install tailscale

section "Finished!"
echo "Now logout and back in for everything to take effect (Cmd + Shift + Q)"

if [[ "$SHELL" != */bash ]]; then
  echo 'Now run: chsh -s "/opt/homebrew/bin/bash"'
fi
