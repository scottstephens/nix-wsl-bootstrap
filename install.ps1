# You need to enable virtualization and WSL before this will work
# dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
# dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

function Get-Input {
    param (
        [string]$prompt,
        [string]$default
    )
    
    $userInput = Read-Host "$prompt [$default]"
    
    if ([string]::IsNullOrWhiteSpace($userInput)) {
        return $default
    } else {
        return $userInput
    }
}

function Get-Good-Temp-File-Path {
    param (
        [string]$baseName,
        [string]$extension
    )
    $badName = [System.IO.Path]::GetRandomFileName()
    $goodName = [System.IO.Path]::GetFileNameWithoutExtension($badName)
    $tempFolder = [System.IO.Path]::GetTempPath()
    $goodPath = "$tempFolder$baseName-$goodName.$extension"
    return $goodPath
}

$windowsUserName = $env:USERNAME
$windowsUserInfo = Get-WmiObject -Class Win32_UserAccount -Filter "Name = '$windowsUserName'"
$fullName = $windowsUserInfo.FullName

$nixUser = Get-Input -prompt "Linux username" -default $windowsUserName
$nixUserFullName = Get-Input -prompt "User's Full Name" -default $fullName
$wslDistroName = Get-Input -prompt "WSL Distro Name" -default "Alpine"
$installFolder = Get-Input -prompt "Install Folder" -default "$env:USERPROFILE\WSL\$wslDistroName"
$multiUser = Get-Input -prompt "Multiuser installation? (Y or N)" -default "Y"

$url = "https://github.com/yuk7/AlpineWSL/releases/latest/download/Alpine.zip"
$outputPath = Get-Good-Temp-File-Path -baseName "Alpine" -extension "zip"
$extractPath = $installFolder
$alpine = "$extractPath\$wslDistroName.exe"

$webClient = New-Object System.Net.WebClient
$webClient.DownloadFile($url, $outputPath)
$shell = New-Object -ComObject Shell.Application
$zipFile = $shell.NameSpace($outputPath)
New-Item -ItemType Directory -Path $extractPath
$destination = $shell.NameSpace($extractPath)
$destination.CopyHere($zipFile.Items(), 16)

if ($wslDistroName -ne "Alpine") {
    Move-Item "$extractPath\Alpine.exe" "$extractPath\$wslDistroName.exe"
}

Remove-Item $outputPath

& $alpine

Write-Output "Done with distro install, starting initialize-root.sh"
Write-Output $nixUser
Write-Output "$nixUserFullName"
Write-Output "`"$env:USERPROFILE`""

wsl -d $wslDistroName --user root ./initialize-root.sh $nixUser "$nixUserFullName" "`"$env:USERPROFILE`"" $multiUser

Write-Output "Done with initialize-root.sh, shutting down wsl"
wsl --shutdown

Write-Output "Running initialize-user-1.sh"
wsl -d $wslDistroName --user $nixUser ./initialize-user-1.sh $multiUser

# Write-Output "Running initialize-user-2.sh"
# wsl -d $wslDistroName --user $nixUser bash --login -c `"./initialize-user-2.sh \`""$env:USERPROFILE"\`"`" $multiUser

# Write-Output "Configuring default username for WSL"
# & $alpine config --default-user $nixUser

# Write-Output "Done!"