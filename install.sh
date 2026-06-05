#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "=== Updating system and syncing repositories ==="
yay -Syu --noconfirm

echo "=== Installing DriftWM, Noctalia Shell, and dependencies ==="
yay -S --noconfirm \
  cmake ninja gcc qt6-base qt6-declarative qt6-wayland \
  wayland wayland-protocols pipewire libxkbcommon wlr-randr wl-clipboard \
  xorg-xwayland xwayland-satellite driftwm noctalia-shell \
  kitty fastfetch fish starship

echo "=== Copying configuration files ==="
mkdir -p ~/.config
# Safely copy files instead of replacing the whole directory
cp -r ~/arch-based-driftwm-dots/.config/* ~/.config/

echo "=== Setting up Fish shell and Starship prompt ==="
# Change the default shell to Fish for the current user
sudo chsh -s /usr/bin/fish "$USER"

# Create fish config directory if it doesn't exist
mkdir -p ~/.config/fish

# Append Starship initialization to config.fish if it's not already there
if ! grep -q "starship init fish" ~/.config/fish/config.fish 2>/dev/null; then
    echo 'starship init fish | source' >> ~/.config/fish/config.fish
fi

echo "=== Installation complete! Launching DriftWM... ==="
exec driftwm
