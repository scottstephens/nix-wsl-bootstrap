$version = "22.05-5c211b47"
$installer_name = "nixos-wsl-installer.tar.gz"
$installer_url = "https://github.com/nix-community/NixOS-WSL/releases/download/$version/$installer_name"
$installer_local_folder = Join-Path -Path "$env:TEMP" -ChildPath "nixos-wsl" | Join-Path -ChildPath $version
$installer_local_path = Join-Path -Path $installer_local_folder -ChildPath $installer_name

if (-not(Test-Path -Path $installer_local_path -PathType Leaf)) {
    New-Item -ItemType Directory -Force -Path $installer_local_folder
    Write-Output "Downloading installer from $installer_url"
    $wc = New-Object net.webclient
    $wc.Downloadfile($installer_url, $installer_local_path)
    Write-Output "Downloaded to $installer_local_path"
} else {
    Write-Output "Found installer at $installer_local_path"
}

$wsl_distro_name = "NixOS"
$install_folder = Join-Path -Path $env:USERPROFILE -ChildPath $wsl_distro_name

if (Test-Path -Path $install_folder -PathType Any) {
    Write-Output "There is an existing folder at the intended install location $install_folder"
    return -1
}

Write-Output "Installing to $install_folder"
wsl --import "$wsl_distro_name" "$install_folder" "$installer_local_path" --version 2
Write-Output "Installation complete. Run wsl -d $wsl_distro_name to start"
Write-Output "To set as default run wsl -s $wsl_distro_name"
