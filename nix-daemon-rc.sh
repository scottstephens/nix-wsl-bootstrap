cat > /etc/init.d/nix-daemon << EOF
#!/sbin/openrc-run

command=nix-daemon
command_args=""
pid_file="/run/\${RC_SVCNAME}.pid"
command_background=true
EOF
