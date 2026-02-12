# Omamac

A poor man's [Omarchy](https://omarchy.org) on macOS using [Aerospace](https://nikitabobko.github.io/AeroSpace/guide) instead of [Hyprland](https://hypr.land/), but with the same terminal setup and most of the basic applications. Offered for those stuck temporarily on a mac, so they can get a simulacrum of the real thing.

## Install

```bash
curl -fsSL https://omamac.org/install | bash
```

## What it sets up

- **Window Manager**: Aerospace (tiling window manager)
- **Terminal**: Alacritty + tmux
- **Shell**: Starship prompt, fzf, eza, zoxide, gum, jq
- **Editors**: nvim, opencode, claude-code
- **Dev tools**: mise (Ruby, Node.js), docker, lazygit, lazydocker
- **Apps**: 1Password, Obsidian, Google Chrome, Dropbox, Spotify, Signal, WhatsApp
- **Networking**: Tailscale
- **Git**: Helpful aliases and config
- **macOS**: Disables conflicting default keybindings, configures dock
