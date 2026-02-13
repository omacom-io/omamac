#!/bin/zsh
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

section() {
  echo -e "\n==> $1\n"
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
section "Installing mise envs..."
mise settings ruby.compile=false
mise use -g ruby
mise use -g node

# Install Omadots
curl -fsSL https://install.omacom.io/dots | zsh

section "Configuring zsh..."
cat >"$HOME/.zshrc" <<'EOF'
eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/.config/shell/all
EOF
echo '[[ -f ~/.zshrc ]] && . ~/.zshrc' >"$HOME/.zprofile"

# Omamac configs
section "Installing config..."
mkdir -p "$HOME/.config"
cp -Rf "$INSTALLER_DIR/config/"* "$HOME/.config/"

osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/AeroSpace.app", hidden:false}' >/dev/null 2>&1 || true

. "$INSTALLER_DIR/install/mac.sh"
echo "✓ macOS"

section "Finished!"
echo "Now logout and back in for everything to take effect (Cmd + Shift + Q)"
