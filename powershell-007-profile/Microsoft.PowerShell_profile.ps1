# This is a comment

function prompt {
    # Get underscore-delimited, TZ-aware, nanosecond-precision timestamp
    $timestamp = Get-UnderscoreTimestamp

    # Get IP address from environment variable
    $ip_address = $env:local_ipv4_address

    # Get hostname from environment
    $hostname = $env:COMPUTERNAME

    # # Get full username (domain\username)
    # $full_username = "$env:USERDOMAIN\$env:USERNAME"
    # Domain\Username -> DOMAIN_backslash_username
    $full_username = ("$env:USERDOMAIN\$env:USERNAME" -replace '\\', '_backslash_')

    # # Get PowerShell version
    # $powershell_version = $PSVersionTable.PSVersion.ToString()
    # PowerShell version -> 7_5_2
    $powershell_version = ($PSVersionTable.PSVersion.ToString() -replace '\.', '_')

    # # Print full info line
    # Write-Host "$timestamp $ip_address $hostname $full_username Powershell $powershell_version" -ForegroundColor Green

    # Build parts list
    $parts = @(
        $timestamp
        $ip_address
        $hostname
        $full_username
        'Powershell'
        $powershell_version
    )

    # Join into one underscore-delimited string
    $output_line = ($parts -join '_')

    # Print the info line
    Write-Host $output_line -ForegroundColor Green

    return "$PWD> "
}

# --- Begin MyModule Logging Block PS-007 ---

# --- Build Timestamp Filename (underscore-normalized) ---
$timestamp = Get-UnderscoreTimestamp

# Get IP, hostname, and full username (env-only; fastest)
$ip_address = ($env:local_ipv4_address -replace '\.', '_')          # 192.168.4.42 -> 192_168_4_42
$hostname   = $env:COMPUTERNAME
$full_user  = ("$env:USERDOMAIN\$env:USERNAME" -replace '\\','_backslash_')  # DOMAIN\user -> DOMAIN_backslash_user

# PowerShell version -> 7_5_2
$ps_ver = ($PSVersionTable.PSVersion.ToString() -replace '\.', '_')

# Compose filename via list + join (no spaces)
$parts = @(
    $timestamp
    $ip_address
    $hostname
    $full_user
    'Powershell'
    $ps_ver
)

# Timestamp already uses _slash_ for TZ; apply a final safety replace just in case
$safe_log_name = (($parts -join '_') -replace '/', '_slash_')

$log_directory = "C:\GitHub-repositories\terminal-logs\powershell-007-logs"
if (!(Test-Path $log_directory)) {
    New-Item -ItemType Directory -Path $log_directory | Out-Null
}

$log_file = Join-Path $log_directory "$safe_log_name.txt"

# --- Start Transcript ---
try {
    Start-Transcript -Path $log_file -Append -ErrorAction Stop
}
catch {
    Write-Host "Transcript already running or failed to start."
}

# --- End MyModule Logging Block PS-007 ---

# Import the Chocolatey Profile that enables tab-completion for 'choco'
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path $ChocolateyProfile) {
    Import-Module "$ChocolateyProfile"
}

# --- Go wrapper: run `go mod tidy` before `go build` ---
function go {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$Args
    )

    # Always invoke the real executable to avoid recursion
    $goExe = "go.exe"

    if ($Args.Count -gt 0 -and $Args[0] -eq "build") {
        # First, tidy modules
        & $goExe mod tidy

        # Then, build with the rest of the args (if any)
        if ($Args.Count -gt 1) {
            & $goExe build @($Args[1..($Args.Count - 1)])
        } else {
            & $goExe build
        }
    }
    else {
        # Pass through other go subcommands unchanged
        & $goExe @Args
    }
}
# --- End Go wrapper ---

function gobuild {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        $Args
    )

    go mod tidy
    go build @Args
}

function gob {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        $Args
    )
    go mod tidy
    go build @Args
}

function gomi {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        $Args
    )
    go mod init @Args
}

# gomo because I mistyped gomi

function gomo {
    param(
        [Parameter(ValueFromRemainingArguments = $true)]
        $Args
    )
    go mod init @Args
}