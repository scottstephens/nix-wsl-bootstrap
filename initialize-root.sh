#!/usr/bin/env bash

echo "In initialize-root.sh with arguments '$1' '$2' '$3' '$4'"

nix_user=$1
nix_user_fullname=$2
windows_user_profile=`wslpath "$3"`
multi_user=$4

echo "Linux path to windows user profile: $windows_user_profile"

echo "Setting up users and groups"
adduser -g "$nix_user_fullname" "$nix_user" -D
adduser "$nix_user" wheel

echo "Installing packages"
apk add sudo shadow curl xz

echo "Configuring passwordless sudo for wheel members"
echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

if [ "$multi_user" != "y" ]; then
    echo "creating /nix and setting permissions suitable for single user nix installation"
    mkdir -m 0755 /nix
    chown "$nix_user" /nix
fi

echo "Setting permissions for Windows files mounted in Linux"
our_uid=`id -u "$nix_user"`
our_gid=`id -g "$nix_user"`
echo "[automount]" > /etc/wsl.conf
echo "options=uid=$our_uid,gid=$our_gid,umask=000,fmask=000,dmask=000" >> /etc/wsl.conf
echo "" >> /etc/wsl.conf

echo "Done with initialize-root.sh"
