# Omamac

Omamac is a keyboard-centric setup for macOS designed for developers working with the terminal. It's inspired by [Omarchy](https://omarchy.org/), and shares the same [Omadots](https://github.com/omacom-io/omadots) for the shell.

It's built on Rectangle Pro for window positioning, Hammerspoon for window navigation, hotkeys for workspace navigation, and Raycast for app launching. It also sets up all the basic developer tooling needed for a Terminal-driven workflow centered around Tmux.

## Install

```bash
curl -fsSL https://omamac.org/install | bash
```

Note: This will overwrite any existing configurations for `.zshrc`, Neovim, and the like. It's intended for a fresh installation.

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
| `Cmd + Ctrl + →` | Focus window to the right |
| `Cmd + Ctrl + ←` | Focus window to the left |
| `Cmd + Ctrl + ↑` | Focus window above |
| `Cmd + Ctrl + ↓` | Focus window below |

### Window Positioning (Rectangle Pro)

| Hotkey | Action |
|--------|--------|
| `Cmd + ⌥ + ←` | Left Half |
| `Cmd + ⌥ + →` | Right Half |
| `Cmd + ⌥ + ↑` | Top Left Quarter |
| `Cmd + ⌥ + ↓` | Bottom Left Quarter |
| `Cmd + ⌥ + Shift + ↑` | Top Right Quarter |
| `Cmd + ⌥ + Shift + ↓` | Bottom Right Quarter |
| `Cmd + ⌥ + Ctrl + ←` | First Fourth (Left) |
| `Cmd + ⌥ + Ctrl + →` | Last Fourth (Right) |
| `Cmd + ⌥ + Ctrl + ↑` | Top Left Eighth |
| `Cmd + ⌥ + Ctrl + ↓` | Bottom Left Eighth |
| `Cmd + ⌥ + Ctrl + Shift + ↑` | Top Right Eighth |
| `Cmd + ⌥ + Ctrl + Shift + ↓` | Bottom Right Eighth |
| `Cmd + ⌥ + Return` | Center Half |
| `Cmd + ⌥ + Ctrl + Return` | Maximize |

### Application Launching (Raycast)

| Hotkey | Action |
|--------|--------|
| `Cmd + Space` | Launcher |
| `Cmd + Ctrl + Return` | Launch Terminal (Alacritty) |
| `Cmd + Ctrl + Shift + Return` | Launch Browser (Chrome) |

### Terminal (Tmux)

You launch tmux with `t` in a new terminal (`Ctrl + Cmd + Return`).

**Prefix key:** `Ctrl + Space` (secondary: `Ctrl + b`)

**Pane Management:**

| Hotkey | Action |
|--------|--------|
| `Prefix + h` | Split horizontally (new pane below) |
| `Prefix + v` | Split vertically (new pane to the right) |
| `Prefix + x` | Kill pane |
| `Ctrl + ⌥ + ←` | Focus left pane |
| `Ctrl + ⌥ + →` | Focus right pane |
| `Ctrl + ⌥ + ↑` | Focus up pane |
| `Ctrl + ⌥ + ↓` | Focus down pane |
| `Ctrl + ⌥ + Shift + ←` | Resize left |
| `Ctrl + ⌥ + Shift + ↓` | Resize down |
| `Ctrl + ⌥ + Shift + ↑` | Resize up |
| `Ctrl + ⌥ + Shift + →` | Resize right |

**Window Management:**

| Hotkey | Action |
|--------|--------|
| `Prefix + c` | New window |
| `Prefix + k` | Kill window |
| `Prefix + r` | Rename window |
| `⌥ + 1` … `⌥ + 9` | Jump to window N |
| `⌥ + ←` | Previous window |
| `⌥ + →` | Next window |
| `⌥ + Shift + ←` | Swap with previous window |
| `⌥ + Shift + →` | Swap with next window |

**Session Management:**

| Hotkey | Action |
|--------|--------|
| `Prefix + Shift + c` | New session |
| `Prefix + Shift + k` | Kill session |
| `Prefix + Shift + r` | Rename session |
| `Prefix + Shift + p` | Previous session |
| `Prefix + Shift + n` | Next session |
| `⌥ + ↑` | Previous session |
| `⌥ + ↓` | Next session |

**Copy Mode (Vi):**

| Hotkey | Action |
|--------|--------|
| `v` | Begin selection |
| `y` | Copy selection |

**Other:**

| Hotkey | Action |
|--------|--------|
| `Ctrl + Space q` | Reload config |

