<#------------------------] Variables [------------------------#>

$width = 80
$backupdir = "C:\Temp\"

<#------------------------] Functions [------------------------#>

<#function Echo-Equals {
    param (
        [int]$length
    )

    $counter = 0
    while ($counter -lt $length) {
        Write-Host "=" -NoNewline
        $counter++
    }
}#>

function Echo-Title {
    param (
        [string]$title
    )

    #$ncols = [console]::WindowWidth
    $nequals = ($width - $title.Length) / 2 -1
    Write-Host ("=" * $nequals) -ForegroundColor Cyan -NoNewline
    Write-Host (" $title ") -ForegroundColor Blue -NoNewline
    Write-Host ("=" * $nequals) -ForegroundColor Cyan
}

<#function Echo-Right {
    param (
        [string]$text
    )

    Write-Host ""
    [console]::CursorTop--
    [console]::CursorLeft = $width - 1 - $text.Length
    Write-Host $text
}#>

function Echo-OK {
    $message = "[ OK ]"
    Write-Host ""
    [console]::CursorTop--
    [console]::CursorLeft = $width - 1 - $message.Length
    Write-Host -ForegroundColor Green $message
}

function Echo-Done {
    $message = "[ Done ]"
    Write-Host ""
    [console]::CursorTop--
    [console]::CursorLeft = $width - 1 - $message.Length
    Write-Host -ForegroundColor Green $message
}

function Echo-NotNeeded {
    $message = "[ Not Needed ]"
    Write-Host ""
    [console]::CursorTop--
    [console]::CursorLeft = $width - 1 - $message.Length
    Write-Host -ForegroundColor DarkYellow $message
}

function Echo-Skipped {
    $message = "[ Skipped ]"
    Write-Host ""
    [console]::CursorTop--
    [console]::CursorLeft = $width - 1 - $message.Length
    Write-Host -ForegroundColor DarkYellow $message
}

function Echo-Failed {
    $message = "[ Failed ]"
    Write-Host ""
    [console]::CursorTop--
    [console]::CursorLeft = $width - 1 - $message.Length
    Write-Host -ForegroundColor Red $message
}

function Antwoord {
    param (
        [string]$question
    )

    $antwoord = Read-Host $question
    if ($antwoord -match "^[yY]") {
        "yes"
    } else {
        "no"
    }
}

function Starship-Querry {
    $InstallStarship = (Antwoord "Do you want to get Starship installed? (Yes|No) >> ")
}
function Starship-Install {
    Write-Host -NoNewline "Installing Starship..."
    if ($InstallStarship -eq "yes") {
        winget install starship
        Echo-Done
    } else {
        Echo-Skipped
    }
}

function StarshipConfig_querry {
    $CopyStarshipConfig = (Antwoord "Do you want to copy Starship config? (Yes|No) >> ")
}
function StarshipConfig_copy {
    Write-Host -NoNewline "Copying starship.toml..."
    if ($CopyStarshipConfig -eq "yes") {
        Copy-Item -Path .\windows\starship.toml -Destination $home\.config\starship.toml
        Echo-Done
    } else {
        Echo-Skipped
    }
}

function Profile_querry {
    $CopyProfile = (Antwoord "Do you want to copy _profile.ps1? (Yes|No) >> ")
}
function Profile_copy {
    Write-Host -NoNewline "Copying _profile.ps1..."
    if ($CopyProfile -eq "yes") {
        Copy-Item -Path .\windows\Microsoft.PowerShell_profile.ps1 -Destination $profile
        Echo-Done
    } else {
        Echo-Skipped
    }
}

function Backup {
    Write-Host -NoNewline "Creating Backup of profile..."
    Copy-Item -Path $profile -Destination ($backupdir + "profile") -Force
    Echo-Done
}

<#------------------------] MAIN [------------------------#>

Echo-Title "Choose Options"
Starship-Querry
StarshipConfig_querry
Profile_querry

Echo-Title "Installing"
Backup
Starship-Install
StarshipConfig_copy
Profile_copy

Echo-Title "I'm done"
Write-Host " "
Write-Host "don't forget to relogin to apply the new configuration"
pause