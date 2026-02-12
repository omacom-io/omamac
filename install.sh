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

# Configure git
if [[ ! -f $HOME/.config/git/config ]]; then
  section "Configuring git..."

  GIT_NAME=$(gum input --placeholder "Your full name" --prompt "Git name: " </dev/tty)
  GIT_EMAIL=$(gum input --placeholder "your@email.com" --prompt "Git email: " </dev/tty)

  download config/git.conf | sed "s/{{GIT_NAME}}/${GIT_NAME}/g; s/{{GIT_EMAIL}}/${GIT_EMAIL}/g" >"$HOME/.config/git/config"
  echo "✓ Git config"
fi

# Copy configs
section "Configuring shell..."

config "Zshrc" config/zshrc "$HOME/.zshrc"
config "Zshprofile" config/zprofile "$HOME/.zprofile"
config "Starship" config/starship.toml "$HOME/.config/starship.toml"
config "Tmux" config/tmux.conf "$HOME/.config/tmux/tmux.conf"

section "Configuring apps..."
config "Alacritty" config/alacritty.toml "$HOME/.config/alacritty/alacritty.toml"
config "Ghostty" config/ghostty.conf "$HOME/.config/ghostty/config"
config "Aerospace" config/aerospace.toml "$HOME/.config/aerospace/aerospace.toml"
osascript -e 'tell application "System Events" to make login item at end with properties {path:"/Applications/AeroSpace.app", hidden:false}' >/dev/null 2>&1 || true

download config/macos/dock.sh | zsh
download config/macos/hotkeys.sh | zsh
echo "✓ macOS"

section "Finished!"
echo "Now logout and back in for everything to take effect (Cmd + Shift + Q)"
