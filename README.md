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
| `Ctrl + Cmd + PageUp` | Split horizontally |
| `Ctrl + Cmd + PageDown` | Split vertically |
| `Ctrl + Cmd + Home` | Split horizontally |
| `Ctrl + Cmd + End` | Kill pane |
| `Ctrl + Cmd + ←` | Focus left pane |
| `Ctrl + Cmd + →` | Focus right pane |
| `Ctrl + Cmd + ↑` | Focus up pane |
| `Ctrl + Cmd + ↓` | Focus down pane |
| `Ctrl + Cmd + Shift + ←` | Resize left |
| `Ctrl + Cmd + Shift + ↓` | Resize down |
| `Ctrl + Cmd + Shift + ↑` | Resize up |
| `Ctrl + Cmd + Shift + →` | Resize right |

**Window Management:**

| Hotkey | Action |
|--------|--------|
| `Ctrl + Shift + Home` | New window |
| `Ctrl + Shift + End` | Kill window |
| `Ctrl + Shift + PageUp` | Next window |
| `Ctrl + Shift + PageDown` | Previous window |
| `Ctrl + Space x` | Kill window |
| `Ctrl + Space r` | Rename window |

**Session Management:**

| Hotkey | Action |
|--------|--------|
| `Ctrl + Cmd + Shift + Home` | New session |
| `Ctrl + Cmd + Shift + End` | Kill session |
| `Ctrl + Cmd + Shift + PageUp` | Previous session |
| `Ctrl + Cmd + Shift + PageDown` | Next session |
| `Ctrl + Space R` | Rename session |
| `Ctrl + Space X` | Kill session |

**Copy Mode (Vi):**

| Hotkey | Action |
|--------|--------|
| `v` | Begin selection |
| `y` | Copy selection |

**Configuration:**

| Hotkey | Action |
|--------|--------|
| `Ctrl + Space q` | Reload tmux config |
