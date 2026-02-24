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
  if ! command -v brew &> /dev/null; then
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

  # Back up shell configs before Omadots overwrites them
  source "$INSTALLER_DIR/install/backup.sh"

  # Initialize install manifest and snapshot pre-existing packages
  local manifest="$HOME/.config/omamac/manifest"
  mkdir -p "$HOME/.config/omamac"
  echo "# omamac install manifest - $(date '+%Y-%m-%d')" > "$manifest"

  local pre_formulas pre_casks
  pre_formulas=$(brew list --formula 2>/dev/null || true)
  pre_casks=$(brew list --cask 2>/dev/null || true)

  section "Installing packages..."
  packages=(tmux mise nvim opencode lazygit lazydocker starship zoxide eza jq gum gh libyaml)
  for pkg in $packages; do
    if echo "$pre_formulas" | grep -qx "$pkg"; then
      echo "formula:$pkg:pre-existing" >> "$manifest"
    else
      brew install "$pkg" || true
      echo "formula:$pkg:installed" >> "$manifest"
    fi
  done

  # Install Alacritty manually from GitHub releases
  section "Installing Alacritty..."
  if [[ -d "/Applications/Alacritty.app" ]]; then
    echo "app:alacritty:pre-existing" >> "$manifest"
    echo "✓ Alacritty (already installed)"
  else
    . "$INSTALLER_DIR/install/alacritty.sh"
    echo "app:alacritty:installed" >> "$manifest"
  fi

  # Install Omadots
  curl -fsSL https://raw.githubusercontent.com/omacom-io/omadots/refs/heads/master/install.sh | zsh
  echo "omadots:omadots:installed" >> "$manifest"

  section "Configuring brew init..."
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$HOME/.config/shell/inits"
  echo "✓ Zsh"

  # Install secondary apps
  section "Installing apps..."
  casks=(rectangle-pro hammerspoon font-jetbrains-mono-nerd-font docker-desktop google-chrome claude-code raycast)
  for cask in $casks; do
    if echo "$pre_casks" | grep -qx "$cask"; then
      echo "cask:$cask:pre-existing" >> "$manifest"
    else
      brew install --cask "$cask" || true
      echo "cask:$cask:installed" >> "$manifest"
    fi
  done

  # Install optional apps
  section "Installing optional apps..."
  selected_apps=$(gum choose --no-limit --height=11 \
    --selected="1password" --selected="dropbox" --selected="spotify" \
    --selected="signal" --selected="whatsapp" --selected="obsidian" \
    --selected="zoom" --selected="localsend" --selected="tailscale" \
    "1password" "dropbox" "spotify" "signal" "whatsapp" "obsidian" "zoom" "localsend" "lm-studio" "tailscale")
  while IFS= read -r app; do
    if [[ -n "$app" ]]; then
      if echo "$pre_casks" | grep -qx "$app"; then
        echo "cask:$app:pre-existing" >> "$manifest"
      else
        brew install --cask "$app" || true
        echo "cask:$app:installed" >> "$manifest"
      fi
    fi
  done <<< "$selected_apps"

  # Install dev environments
  section "Installing dev environments..."
  selected_langs=$(gum choose --no-limit --height=15 \
    --selected="node" --selected="ruby" \
    "node" "ruby" "python" "go" "rust" "java" "php" "elixir" "erlang" "scala" "kotlin" "deno" "bun")
  while IFS= read -r lang; do
    if [[ -n "$lang" ]]; then
      mise use -g "$lang" || true
      echo "mise:$lang:installed" >> "$manifest"
    fi
  done <<< "$selected_langs"

  # Omamac configs
  section "Configuring Mac..."
  mkdir -p "$HOME/.config"
  cp -Rf "$INSTALLER_DIR/config/"* "$HOME/.config/"
  for dir in "$INSTALLER_DIR/config"/*/; do
    local cfg_name
    cfg_name=$(basename "$dir")
    echo "config:$cfg_name:installed" >> "$manifest"
    echo "✓ $cfg_name"
  done

  # Create hush file to suppress "Last login" message
  touch "$HOME/.hushlogin"
  echo "✓ Hush login"

  . "$INSTALLER_DIR/install/mac.sh"
  echo "✓ Settings"

  # Correct hammerspoon config location
  defaults write org.hammerspoon.Hammerspoon MJConfigFile "$HOME/.config/hammerspoon/init.lua"

  # Done!
  section "Finished!"
  echo "1. You must manually create the nine default workspaces with F3"
  echo "2. Manually disable all Keyboard Shortcuts for Windows + Spotlight + Mission Control"
  echo "3. Manually enable 'Switch to Desktop' Keyboard Shortcuts on CMD-[1-9]"
  echo "4. Manually import Rectangle Pro config from ~/.config/rectangle/RectangleProConfig.json (reveal hidden with Cmd + Shift + . in Finder)"
  echo "5. Manually import Raycast config from ~/.config/raycast/Raycast.rayconfig with pw: 12345678"
  echo "6. Remember to authenticate with: gh auth login"
  echo "7. Then logout and back in for everything to take effect (Cmd + Shift + Q)"
  echo
  if [[ -f "$HOME/.config/omamac/backups" ]]; then
    echo "✓ Shell config backup: $(tail -1 "$HOME/.config/omamac/backups")"
  fi
  echo "  To uninstall: curl -fsSL https://raw.githubusercontent.com/omacom-io/omamac/main/uninstall.sh | zsh"

  open -a "Hammerspoon"
  open -a "Rectangle Pro"
  open -a "Raycast"
  open -a "Tailscale"
}

# Must use a function to prevent brew installs from stealing stdin
install
