
# Install required modules
Install-Module posh-git -Scope CurrentUser
Install-Module oh-my-posh -Scope CurrentUser
Install-Module -Name PSDotFiles -Scope CurrentUser

# Fix git, SSH and GPG to external executables
[Environment]::SetEnvironmentVariable('GIT_SSH', "$ENV:SystemRoot\System32\OpenSSH\ssh.exe", 'User')
[Environment]::SetEnvironmentVariable('GNUPGHOME', "$ENV:APPDATA\gnupg", 'User')
Invoke-Expression "git config --global gpg.program 'c:/Program Files (x86)/GnuPG/bin/gpg.exe'"