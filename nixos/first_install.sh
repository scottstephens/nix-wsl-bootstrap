#!/usr/bin/env bash

version="22.05-5c211b47"
installer_name="nixos-wsl-installer.tar.gz"
installer_url="https://github.com/nix-community/NixOS-WSL/releases/download/$version/$installer_name"
installer_local_folder="$TMP/nixos-wsl/$version/"
installer_local_path="$installer_local_folder/$installer_name"
if [ ! -e $installer_local_path ]; then
    mkdir -p $installer_local_folder
    echo "Downloading installer from $installer_url"
    curl "$installer_url" --output $installer_local_path
    echo "Downloaded to $installer_local_path"
else
    echo "Found installer at $installer_local_path"
fi

wsl_distro_name="NixOS"
install_folder="$HOME/$wsl_distro_name"

if [ -d $install_folder ]; then
    echo "There is an existing folder at the intended install location $install_folder"
    return -1
fi

echo "Installing to $install_folder"
wsl --import "$wsl_distro_name" "$install_folder" "$installer_local_path" --version 2

echo "Installation complete. Run wsl to start"