bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Change from zsh to bash
brew install bash
chsh -s "/opt/homebrew/bin/bash"

brew install tmux mise starship zoxide eza
