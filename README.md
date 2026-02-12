# Omamac

A poor man's [Omarchy](https://omarchy.org) on macOS using [Aerospace](https://nikitabobko.github.io/AeroSpace/guide) instead of [Hyprland](https://hypr.land/), but with the same terminal setup and most of the basic applications. Offered for those stuck temporarily on a mac, so they can get a simulacrum of the real thing.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/omacom-io/omamac/master/install.sh | bash
```

## What it sets up

- **Window Manager**: Aerospace (tiling window manager)
- **Terminal**: Alacritty + tmux
- **Shell**: Bash (switches from zsh) with starship prompt, fzf, eza, zoxide, gum, jq
- **Editors**: opencode, claude-code, Obsidian
- **Dev tools**: mise (Ruby, Node.js), lazygit, docker
- **Apps**: 1Password, Google Chrome, Dropbox, Spotify, Signal, WhatsApp
- **Networking**: Tailscale
- **Git**: Helpful aliases and config
- **macOS**: Disables conflicting default keybindings, configures dock
