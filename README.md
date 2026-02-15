# Omamac

Omamac is a keyboard-centric setup for macOS that takes inspiration from [Omarchy](https://omarchy.org/). It's built on Rectangle Pro for window positioning, Hammerspoon for window navigation, hotkeys for workspace navigation, and Raycast for app launching. It also sets up all the basic developer tooling needed for a Terminal-driven workflow centered around Tmux.

## Install

```bash
curl -fsSL https://omamac.org/install | bash
```

## What it sets up

- **Window Management**: Rectangle Pro, Hammerspoon, Raycast
- **Terminal**: Alacritty, Tmux
- **Shell**: Starship prompt, fzf, eza, zoxide
- **Editors**: nvim, opencode, claude-code
- **Dev tools**: mise (Ruby, Node.js), Docker, lazygit, lazydocker
- **Apps**: 1Password, Obsidian, Google Chrome, Dropbox, Spotify, Signal, WhatsApp
- **Networking**: Tailscale
- **Git**: Helpful aliases and config

## Hotkeys

### Window Navigation (Hammerspoon)

| Hotkey | Action |
|--------|--------|
| `Cmd+Ctrl+→` | Focus window to the right |
| `Cmd+Ctrl+←` | Focus window to the left |
| `Cmd+Ctrl+↑` | Focus window above |
| `Cmd+Ctrl+↓` | Focus window below |

### Window Positioning (Rectangle Pro)

| Hotkey | Action |
|--------|--------|
| `Cmd+Ctrl+←` | Left Half |
| `Cmd+Ctrl+→` | Right Half |
| `Cmd+Ctrl+↑` | Top Left Quarter |
| `Cmd+Ctrl+↓` | Bottom Left Quarter |
| `Cmd+Ctrl+Shift+↑` | Top Right Quarter |
| `Cmd+Ctrl+Shift+↓` | Bottom Right Quarter |
| `Cmd+Ctrl+⌥+←` | First Fourth (Left) |
| `Cmd+Ctrl+⌥+→` | Last Fourth (Right) |
| `Cmd+Ctrl+⌥+↑` | Top Left Eighth |
| `Cmd+Ctrl+⌥+↓` | Bottom Left Eighth |
| `Cmd+Ctrl+⌥+Shift+↑` | Top Right Eighth |
| `Cmd+Ctrl+⌥+Shift+↓` | Bottom Right Eighth |
| `Cmd+Ctrl+Return` | Center Half |
| `Cmd+Ctrl+⌥+Return` | Maximize |

### Application Launching (Raycast)

| Hotkey | Action |
|--------|--------|
| `Cmd+Space` | Launcher |
| `Cmd+Ctrl+Return` | Launch Terminal (Alacritty) |
| `Cmd+Ctrl+Shift+Return` | Launch Browser (Chrome) |

