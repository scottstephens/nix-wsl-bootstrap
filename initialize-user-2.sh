#!/usr/bin/env bash

echo "Starting initialize-user-2.sh with arguments '$1' '$2'"

windows_user_profile=`wslpath "$1"`
multi_user=$2

echo "Linux path to windows user profile: $windows_user_profile"

create_symlink() {
  local file_path="$1"
  local dest_folder="$2"
  local dest_name=$(basename "$1")
  local dest_path="$dest_folder/$dest_name"
  ln -s "$file_path" "$dest_folder/$dest_name"
}

if [ $multi_user = "y" ]; then
  echo "Waiting for nix-daemon to start"
  while ! pgrep -f "nix-daemon" > /dev/null; do
      sleep 0.1
  done
fi

echo "Installing basic packages"
nix-env -i openssh git vim

mkdir -p ~/.ssh
chmod 700 ~/.ssh

export -f create_symlink

find $windows_user_profile/.ssh -name id_* -exec bash --login -c 'create_symlink {} ~/.ssh' \;

echo "Done with initialize-user-2.sh"
