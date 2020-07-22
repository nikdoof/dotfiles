# Add a SSH key to SSH-Agent
function Add-SshKey {
    if ($args.Count -gt 0) {
        $filename = "$ENV:USERPROFILE\.ssh\id_ed25519_" + $args[0]
        if (!(Test-Path $filename -PathType Leaf)) {
            Write-Error "$filename does not exist."
        }
        else {
            Invoke-Expression "ssh-add $filename"   
        }
    }
    else {
        Invoke-Expression "ssh-add -L"
    }
}

function Clear-SshKeys {
    Invoke-Expression "ssh-add -D"
}

function Update-Dotfiles {
    Join-Path $HOME '.dotfiles' | Push-Location
    Invoke-Expression -Command "git pull --rebase --autostash"
    Pop-Location 
}

$DotFilesPath = Join-Path $HOME '.dotfiles'
$DotFilesAutodetect = $true
$DotFilesAllowNestedSymlinks = $true

Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox