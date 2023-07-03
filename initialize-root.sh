#!/usr/bin/env bash

echo "Arguments: $1 $2 $3"

nix_user=$1
nix_user_fullname=$2
windows_user_profile=`wslpath "$3"`

echo "windows_user_profile $windows_user_profile"

adduser -g "$nix_user_fullname" "$nix_user" -D
adduser "$nix_user" wheel
apk add sudo shadow curl xz
echo '%wheel ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/wheel

mkdir -m 0755 /nix
chown "$nix_user" /nix

our_uid=`id -u "$nix_user"`
our_gid=`id -g "$nix_user"`
echo "[automount]" > /etc/wsl.conf
echo "options=uid=$our_uid,gid=$our_gid,umask=000,fmask=000,dmask=000" >> /etc/wsl.conf

echo "Done with initialize-root.sh"
