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

download() {
  local url="https://raw.githubusercontent.com/omacom-io/omamac/master/$1"
  if ! curl -fsSL "$url"; then
    echo "Failed to download: $1" >&2
    exit 1
  fi
}

section() {
  echo e "\n==> $1\n"
}

config() {
  mkdir -p "$(dirname "$3")"
  download "$2" >"$3"
  echo "✓ $1"
}

if ! command -v brew >/dev/null 2>&1; then
  section "Installing brew..."
  curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | zsh
fi

# Install all packages from Brewfile
section "Installing packages..."
download Brewfile | brew bundle --file=-

# Install Alacritty manually from GitHub releases
section "Installing Alacritty..."
download install/alacritty.sh | zsh

# Install basic dev envs
section "Installing mise envs..."
mise settings ruby.compile=false
mise use -g ruby
mise use -g node

# Install Omadots
curl -fsSL https://install.omacom.io/dots | bash

section "Configuring zsh..."
cat >>"$HOME/.zshrc" <<'EOF'
eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/.config/shell/all
EOF
echo '[[ -f ~/.zshrc ]] && . ~/.zshrc' >"$HOME/.bash_profile"

# ─────────────────────────────────────────────
# Omamac configs
# ─────────────────────────────────────────────
REPO="https://github.com/omacom-io/omaterm.git"
TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

section "Cloning Omamac..."
git clone --depth 1 "$REPO" "$TMPDIR"

section "Installing config..."
mkdir -p "$HOME/.config"
cp -Rf "$TMPDIR/config/"* "$HOME/.config/"

osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/AeroSpace.app", hidden:false}' >/dev/null 2>&1 || true

download config/macos/dock.sh | zsh
download config/macos/hotkeys.sh | zsh
echo "✓ macOS"

section "Finished!"
echo "Now logout and back in for everything to take effect (Cmd + Shift + Q)"
