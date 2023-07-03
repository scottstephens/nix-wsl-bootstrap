#!/usr/bin/env bash

nix_user=$1
nix_user_fullname=$2
windows_user_profile=wslpath "$3"

adduser -g "$nix_user_fullname" "$nix_user" -D
adduser "$nix_user" wheel
apk add sudo shadow curl xz
echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

mkdir -m 0755 /nix
chown "$nix_user" /nix

su "$nix_user" -c 'sh <(curl -L https://nixos.org/nix/install) --no-daemon'
su "$nix_user" -c "echo \". /home/$nix_user/.nix-profile/etc/profile.d/nix.sh\" >> ~/.profile"
su "$nix_user" -l -c "initialize-user.sh $windows_user_profile"
