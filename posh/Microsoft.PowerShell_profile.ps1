# Add a SSH key to SSH-Agent
function Add-Key {
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

$DotFilesPath = Join-Path $HOME '.dotfiles'
$DotFilesAutodetect = $true
$DotFilesAllowNestedSymlinks = $true

Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox