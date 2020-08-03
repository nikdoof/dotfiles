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

function Send-0x0 {
    [CmdletBinding()]
    PARAM
    (
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$File,
        [Uri]$Service = 'http://0x0.st/'
    )
    BEGIN {
        if (-not (Test-Path $File)) {
            $errorMessage = ("File {0} missing or unable to read." -f $File)
            $exception = New-Object System.Exception $errorMessage
            $errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, 'MultipartFormDataUpload', ([System.Management.Automation.ErrorCategory]::InvalidArgument), $File
            $PSCmdlet.ThrowTerminatingError($errorRecord)
        }
    }
    PROCESS {
        Add-Type -AssemblyName System.Net.Http
        Add-Type -AssemblyName System.Web

        $httpClientHandler = New-Object System.Net.Http.HttpClientHandler
        $httpClient = New-Object System.Net.Http.Httpclient $httpClientHandler
        $packageFileStream = New-Object System.IO.FileStream @((Resolve-Path $File), [System.IO.FileMode]::Open)

        $contentDispositionHeaderValue = New-Object System.Net.Http.Headers.ContentDispositionHeaderValue "form-data"
        $contentDispositionHeaderValue.Name = "file"
        $contentDispositionHeaderValue.FileName = (Split-Path $File -leaf)

        $streamContent = New-Object System.Net.Http.StreamContent $packageFileStream
        $streamContent.Headers.ContentDisposition = $contentDispositionHeaderValue
        $mimeType = [System.Web.MimeMapping]::GetMimeMapping($File)
        if ($mimeType) {
            $ContentType = $mimeType
        }
        else {
            $ContentType = "application/octet-stream"
        }
        $streamContent.Headers.ContentType = New-Object System.Net.Http.Headers.MediaTypeHeaderValue $ContentType

        $content = New-Object System.Net.Http.MultipartFormDataContent
        $content.Add($streamContent)

        try {
            $response = $httpClient.PostAsync($Service, $content).Result
            if (!$response.IsSuccessStatusCode) {
                $responseBody = $response.Content.ReadAsStringAsync().Result
                $errorMessage = "Status code {0}. Reason {1}. Server reported the following message: {2}." -f $response.StatusCode, $response.ReasonPhrase, $responseBody

                throw [System.Net.Http.HttpRequestException] $errorMessage
            }
            $responseBody = $response.Content.ReadAsStringAsync().Result
            return "URL: {0}" -f $responseBody
        }
        catch [Exception] {
            $PSCmdlet.ThrowTerminatingError($_)
        }
        finally {
            if ($null -ne $httpClient) {
                $httpClient.Dispose()
            }

            if ($null -ne $response) {
                $response.Dispose()
            }
        }
    }
    END { }
}

$DotFilesPath = Join-Path $HOME '.dotfiles'
$DotFilesAutodetect = $true
$DotFilesAllowNestedSymlinks = $true

Import-Module posh-git
Import-Module oh-my-posh
Set-Theme Paradox