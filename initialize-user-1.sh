#!/usr/bin/env bash

echo "Starting initialize-user-1.sh"

sh <(curl -L https://nixos.org/nix/install) --no-daemon
echo ". /home/$USER/.nix-profile/etc/profile.d/nix.sh" >> ~/.profile

mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes

EOF

echo "Done with initialize-user-1.sh"
