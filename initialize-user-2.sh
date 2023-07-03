#!/usr/bin/env bash

echo "Starting initialize-user-2.sh"
echo "Arguments $1"

windows_user_profile=`wslpath "$1"`

echo "windows_user_profile $windows_user_profile"

create_symlink() {
  local file_path="$1"
  local dest_folder="$2"
  local dest_name=$(basename "$1")
  local dest_path="$dest_folder/$dest_name"
  ln -s "$file_path" "$dest_folder/$dest_name"
}

nix-env -i openssh git vim

mkdir -p ~/.ssh
chmod 700 ~/.ssh

export -f create_symlink

find $windows_user_profile/.ssh -name id_* -exec bash --login -c 'create_symlink {} ~/.ssh' \;
