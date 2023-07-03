#!/usr/bin/env bash

windows_user_profile=$1

create_symlink() {
  local file_path="$1"
  local dest_folder="$2"
  local dest_name=$(basename "$1")
  local old_umask=$(umask)
  local dest_path="$dest_folder/$dest_name"
  ln -s "$file_path" "$dest_folder/$dest_name"
}

sh <(curl -L https://nixos.org/nix/install) --no-daemon
echo ". /home/$USER/.nix-profile/etc/profile.d/nix.sh" >> ~/.profile

mkdir -p ~/.config/nix
cat > ~/.config/nix/nix.conf << EOF
experimental-features = nix-command flakes

EOF

nix-env -i openssh git vim
mkdir -p ~/.ssh
chmod 700 ~/.ssh

export -f create_symlink
find $windows_user_profile/.ssh -name id_* -exec bash -c 'create_symlink {} ~/.ssh' \;