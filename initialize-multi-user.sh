#!/usr/bin/env bash

adduser -g "Scott Stephens" scott -D
adduser scott wheel
apk add sudo shadow openrc curl xz
echo '%wheel ALL=(ALL) ALL' > /etc/sudoers.d/wheel
mkdir -m 0755 /nix
chown scott /nix
wget -q -O - https://nixos.org/nix/install | sh -s

cat > /etc/init.d/nix-daemon << EOF
#!/sbin/openrc-run

command=nix-daemon
command_args=""
pid_file="/run/\${RC_SVCNAME}.pid"
command_background=true
EOF

chmod o+x /etc/init.d/nix-daemon