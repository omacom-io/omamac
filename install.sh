if ! command -v brew; then
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Change from zsh to bash
brew install bash
chsh -s "/opt/homebrew/bin/bash"

# Install basic tools
brew install aerospace tmux mise opencode lazygit starship zoxide eza jq gum
brew install font-jetbrains-mono-nerd-font
brew install tailscale

# Install GUI applications via cask
brew install --cask dropbox spotify signal whatsapp obsidian claude-code

# Install Alacritty manually from GitHub releases
bash ./install/alacritty.sh

# Install basic dev envs
mise settings ruby.compile=false
mise use -g ruby
mise use -g node

# Copy configs
mkdir -p .config/
cp ./config/bashrc ~/.bashrc
cp ./config/aerospace.toml ~/.aerospace.toml

mkdir -p .config/alacritty
cp ./config/alacritty.toml ~/.config/alacritty/alacritty.toml

mkdir -p .config/tmux
cp ./config/tmux.conf ~/.config/tmux/tmux.conf

mkdir -p .config/git
cp ./config/git.conf ~/.config/git/config
