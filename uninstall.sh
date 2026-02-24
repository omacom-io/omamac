#!/bin/zsh
set -euo pipefail

uninstall() {
  clear
  echo
  echo " ▄██████▄    ▄▄▄▄███▄▄▄▄      ▄████████   ▄▄▄▄███▄▄▄▄      ▄████████  ▄████████"
  echo "███    ███ ▄██▀▀▀███▀▀▀██▄   ███    ███ ▄██▀▀▀███▀▀▀██▄   ███    ███ ███    ███"
  echo "███    ███ ███   ███   ███   ███    ███ ███   ███   ███   ███    ███ ███    █▀ "
  echo "███    ███ ███   ███   ███   ███    ███ ███   ███   ███   ███    ███ ███       "
  echo "███    ███ ███   ███   ███ ▀███████████ ███   ███   ███ ▀███████████ ███       "
  echo "███    ███ ███   ███   ███   ███    ███ ███   ███   ███   ███    ███ ███    █▄ "
  echo "███    ███ ███   ███   ███   ███    ███ ███   ███   ███   ███    ███ ███    ███"
  echo " ▀██████▀   ▀█   ███   █▀    ███    █▀   ▀█   ███   █▀    ███    █▀  ████████▀ "
  echo
  echo "                              U N I N S T A L L E R"
  echo

  section() { echo -e "\n==> $1"; }

  local manifest="$HOME/.config/omamac/manifest"
  local formulas=()
  local casks=()
  local configs=()
  local has_alacritty=0
  local has_omadots=0

  # Read install manifest to know what omamac actually installed
  if [[ -f "$manifest" ]]; then
    echo "✓ Install manifest found — only packages installed by omamac are listed."
    echo "  Pre-existing packages you had before omamac are excluded."
    echo

    local line type name status
    while IFS= read -r line; do
      [[ "$line" == \#* || -z "$line" ]] && continue
      type="${line%%:*}"
      line="${line#*:}"
      name="${line%%:*}"
      status="${line#*:}"
      status="${status%%:*}"
      [[ "$status" != "installed" ]] && continue
      case "$type" in
        formula) formulas+=("$name") ;;
        cask)    casks+=("$name") ;;
        app)     [[ "$name" == "alacritty" ]] && has_alacritty=1 ;;
        omadots) has_omadots=1 ;;
        config)  configs+=("$name") ;;
      esac
    done < "$manifest"
  else
    echo "⚠ No install manifest found (older install or manual setup)."
    echo "  All known omamac packages are listed — pre-existing ones may be included."
    echo
    formulas=(tmux mise nvim opencode lazygit lazydocker starship zoxide eza jq gum gh libyaml)
    casks=(rectangle-pro hammerspoon font-jetbrains-mono-nerd-font docker-desktop google-chrome claude-code raycast)
    configs=(alacritty ghostty hammerspoon raycast rectangle)
    has_alacritty=1
    has_omadots=1
  fi

  # Save backup path now in case ~/.config/omamac gets removed later
  local latest_backup=""
  local backups_file="$HOME/.config/omamac/backups"
  if [[ -f "$backups_file" ]]; then
    latest_backup=$(tail -1 "$backups_file")
  fi

  local rm_formulas=()
  local rm_casks=()
  local rm_alacritty=0
  local rm_configs=0
  local rm_omadots=0

  if command -v gum &>/dev/null; then
    local choices=()
    for f in "${formulas[@]}"; do choices+=("cli: $f"); done
    for c in "${casks[@]}";    do choices+=("app: $c"); done
    if (( has_alacritty )); then choices+=("app: alacritty  (installed from DMG)"); fi
    if [[ ${#configs[@]} -gt 0 ]]; then
      choices+=("config: omamac dotfiles in ~/.config/")
    fi
    if (( has_omadots )); then
      choices+=("dotfiles: omadots shell config  (~/.config/shell, nvim, starship, tmux)")
    fi

    if [[ ${#choices[@]} -eq 0 ]]; then
      echo "Nothing to remove."; return 0
    fi

    local selected
    selected=$(printf '%s\n' "${choices[@]}" | \
      gum choose --no-limit --header "Select what to remove (space=toggle, enter=confirm):" || true)

    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      case "$line" in
        "cli: "*)          rm_formulas+=("${line#cli: }") ;;
        "app: alacritty"*) rm_alacritty=1 ;;
        "app: "*)          rm_casks+=("${line#app: }") ;;
        "config: "*)       rm_configs=1 ;;
        "dotfiles: "*)     rm_omadots=1 ;;
      esac
    done <<< "$selected"
  else
    # Plain prompts fallback (gum not installed)
    echo "Packages to remove:"
    for f in "${formulas[@]}"; do echo "  [cli] $f"; done
    for c in "${casks[@]}";    do echo "  [app] $c"; done
    if (( has_alacritty )); then echo "  [app] alacritty"; fi
    echo

    local ans
    printf "Remove all listed packages? [y/N]: "
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
      rm_formulas=("${formulas[@]}")
      rm_casks=("${casks[@]}")
      if (( has_alacritty )); then rm_alacritty=1; fi
    fi

    if [[ ${#configs[@]} -gt 0 ]]; then
      printf "Remove omamac configs from ~/.config/? [y/N]: "
      read ans
      [[ "$ans" =~ ^[Yy]$ ]] && rm_configs=1
    fi

    if (( has_omadots )); then
      printf "Remove omadots shell dotfiles? [y/N]: "
      read ans
      [[ "$ans" =~ ^[Yy]$ ]] && rm_omadots=1
    fi
  fi

  # Nothing selected
  if [[ ${#rm_formulas[@]} -eq 0 && ${#rm_casks[@]} -eq 0 \
     && $rm_alacritty -eq 0 && $rm_configs -eq 0 && $rm_omadots -eq 0 ]]; then
    echo "Nothing selected. Exiting."
    return 0
  fi

  # Summary before confirming
  section "Will remove:"
  for pkg in "${rm_formulas[@]}"; do echo "  $pkg"; done
  for csk in "${rm_casks[@]}";    do echo "  $csk  (cask)"; done
  if (( rm_alacritty )); then echo "  Alacritty.app"; fi
  if (( rm_configs ));   then echo "  omamac configs: ${(j:, :)configs}"; fi
  if (( rm_omadots ));   then echo "  omadots shell dotfiles"; fi
  echo

  local ans
  printf "Proceed? [y/N]: "
  read ans
  [[ ! "$ans" =~ ^[Yy]$ ]] && { echo "Aborted."; return 0; }

  echo

  # Remove brew formulas
  for pkg in "${rm_formulas[@]}"; do
    brew uninstall "$pkg" 2>/dev/null && echo "✓ Removed $pkg" \
      || echo "⚠ Could not remove $pkg (may have dependents — remove manually)"
  done

  # Remove brew casks
  for csk in "${rm_casks[@]}"; do
    brew uninstall --cask "$csk" 2>/dev/null && echo "✓ Removed $csk" \
      || echo "⚠ Could not remove $csk"
  done

  # Remove Alacritty (was installed from DMG, not brew)
  if (( rm_alacritty )) && [[ -d "/Applications/Alacritty.app" ]]; then
    sudo rm -rf "/Applications/Alacritty.app"
    echo "✓ Removed Alacritty.app"
  fi

  # Remove omamac configs
  if (( rm_configs )); then
    for cfg in "${configs[@]}"; do
      local cfg_path="$HOME/.config/$cfg"
      if [[ -d "$cfg_path" ]]; then
        rm -rf "$cfg_path"
        echo "✓ Removed ~/.config/$cfg"
      fi
    done
    if [[ -d "$HOME/.config/omamac" ]]; then
      rm -rf "$HOME/.config/omamac"
      echo "✓ Removed ~/.config/omamac"
    fi
  fi

  # Remove omadots shell dotfiles
  if (( rm_omadots )); then
    for d in shell nvim starship tmux; do
      local dp="$HOME/.config/$d"
      if [[ -d "$dp" ]]; then
        rm -rf "$dp"
        echo "✓ Removed ~/.config/$d"
      fi
    done
    if [[ -f "$HOME/.hushlogin" ]]; then
      rm -f "$HOME/.hushlogin"
      echo "✓ Removed ~/.hushlogin"
    fi
  fi

  # Offer to restore shell config backup
  if [[ -n "$latest_backup" && -d "$latest_backup" ]]; then
    section "Restore shell config backup?"
    echo "  Found: $latest_backup"
    ls -1 "$latest_backup" 2>/dev/null | while IFS= read -r f; do echo "    $f"; done
    echo

    local ans
    printf "Restore to ~/? [y/N]: "
    read ans
    if [[ "$ans" =~ ^[Yy]$ ]]; then
      cp "$latest_backup"/* "$HOME/"
      echo "✓ Shell config restored"
    fi
  fi

  section "Done!"
  echo "Restart your terminal for changes to take effect."
  echo
  echo "To also remove Homebrew:"
  echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)\""
}

# Must use a function to prevent brew operations from stealing stdin
uninstall
