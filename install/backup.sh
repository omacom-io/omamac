#!/bin/zsh
# Shell config backup utility for omamac.
# Sourced by install.sh right after cloning, before Omadots overwrites shell config.
# Can also be run standalone: zsh install/backup.sh

omamac_backup() {
  echo
  echo "==> Shell Config Backup"
  echo "Omadots will overwrite your shell config. Back up your existing files first."
  echo

  # Detect current shell
  local detected=""
  case "$SHELL" in
    */zsh)  detected="zsh"  ;;
    */bash) detected="bash" ;;
    */fish) detected="fish" ;;
  esac

  local default=1
  [[ "$detected" == "bash" ]] && default=2
  [[ "$detected" == "fish" ]] && default=3

  printf "  [1] zsh  — ~/.zshrc, ~/.zprofile, ~/.zshenv"
  [[ "$detected" == "zsh"  ]] && printf "  ← current"
  echo
  printf "  [2] bash — ~/.bashrc, ~/.bash_profile, ~/.profile"
  [[ "$detected" == "bash" ]] && printf "  ← current"
  echo
  printf "  [3] fish — ~/.config/fish/config.fish"
  [[ "$detected" == "fish" ]] && printf "  ← current"
  echo
  echo "  [4] Custom path"
  echo "  [5] Skip (not recommended)"
  echo

  local choice
  printf "Choice [%d]: " "$default"
  read choice
  [[ -z "$choice" ]] && choice=$default

  local files=()
  case "$choice" in
    1) files=("$HOME/.zshrc" "$HOME/.zprofile" "$HOME/.zshenv" "$HOME/.zlogin") ;;
    2) files=("$HOME/.bashrc" "$HOME/.bash_profile" "$HOME/.profile" "$HOME/.bash_login") ;;
    3) files=("$HOME/.config/fish/config.fish") ;;
    4)
      local custom_path
      printf "Path to file or directory: "
      read custom_path
      custom_path="${custom_path/#\~/$HOME}"
      if [[ ! -e "$custom_path" ]]; then
        echo "⚠ Not found: $custom_path — skipping backup."
        return 0
      fi
      files=("$custom_path")
      ;;
    *) echo "Skipping backup."; return 0 ;;
  esac

  # Filter to files that actually exist
  local existing=()
  for f in "${files[@]}"; do
    [[ -f "$f" ]] && existing+=("$f")
  done

  if [[ ${#existing[@]} -eq 0 ]]; then
    echo "No existing config files found for that shell — skipping backup."
    return 0
  fi

  echo
  echo "Found:"
  for f in "${existing[@]}"; do echo "  $f"; done
  echo

  local confirm
  printf "Create backup? [Y/n]: "
  read confirm
  [[ "$confirm" =~ ^[Nn]$ ]] && { echo "Skipping."; return 0; }

  local backup_dir="$HOME/.omamac_backup_$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$backup_dir"
  for f in "${existing[@]}"; do
    cp "$f" "$backup_dir/"
    echo "  ✓ $(basename "$f")"
  done

  mkdir -p "$HOME/.config/omamac"
  echo "$backup_dir" >> "$HOME/.config/omamac/backups"

  echo
  echo "✓ Backup: $backup_dir"
  echo "  Restore: cp \"$backup_dir\"/* ~/"
}

omamac_backup
