$wsl_name = "NixOS"
$baseFolder = if ($PSScriptRoot -ne "") { $PSScriptRoot } else { Get-Location }

$wsl_path = "$baseFolder".Replace(":","").Replace('\','/')
$drive = $wsl_path[0].ToString().ToLower()
$end_path = $wsl_path.Substring(2)
$final_path = "/mnt/$drive/$end_path"

wsl -d $wsl_name --shell-type standard -- mkdir -p ~/setup
Copy-Item . -Destination "\\wsl.localhost\NixOS\home\nixos\setup" -Recurse -Exclude .\.git
# wsl -d NixOS --exec "cd ~/setup && nixos-rebuild --flake . switch"
