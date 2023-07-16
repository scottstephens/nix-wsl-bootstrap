#!/usr/bin/env bash

echo "Starting initialize-user-1.sh with arguments '$1'"

multi_user=$1

if [ $multi_user = "Y" ]; then 
    daemon_arg="--daemon"
else 
    daemon_arg="--no-daemon" 
fi

# echo "Installing Nix"
# sh <(curl -L https://nixos.org/nix/install) $daemon_arg
# echo ". /home/$USER/.nix-profile/etc/profile.d/nix.sh" >> ~/.profile

echo "Creating nix config file"
configContent="experimental-features = nix-command flakes"
if [ $multi_user = "Y" ]; then 
    conf_folder="/etc/nix"
    conf_file="$conf_folder/nix.conf"
    cp $conf_file .
    chown $USER nix.conf
    cat >> "nix.conf" << EOF
$configContent

EOF
    sudo mv -f "nix.conf" $conf_file
    sudo chown root:root $conf_file
    sudo chmod u=rw,g=rw,o=r $conf_file
else
    conf_folder="~/.config/nix"
    mkdir -p "$conf_folder"
    cat > "$conf_folder/nix.conf" << EOF
$configContent

EOF
fi

echo "Done with initialize-user-1.sh"
