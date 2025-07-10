# This is a comment

Import-Module C:\powershell-modules\MyModule\MyModule.psm1

function prompt {
    $now = Get-Date

    # Use high-precision timestamp (7 fractional digits)
    $timestamp = $now.ToString("yyyy-0MM-0dd 0HH.0mm.0ss.fffffff")

    $iana_tz = Get-IanaTimeZone
    $iso_week_date = Get-IsoWeekDate -date $now
    $iso_ordinal_date = Get-IsoOrdinalDate -date $now

    # Get IP address from environment variable
    $ip_address = $env:local_ipv4_address

    # Get hostname from environment
    $hostname = $env:COMPUTERNAME

    # Get full username (domain\username)
    $full_username = "$env:USERDOMAIN\$env:USERNAME"

    # Get PowerShell version
    $powershell_version = $PSVersionTable.PSVersion.ToString()

    # Print full info line
    Write-Host "$timestamp $iana_tz $iso_week_date $iso_ordinal_date $ip_address $hostname $full_username Powershell $powershell_version" -ForegroundColor Green

    return "$PWD> "
}

# --- Begin MyModule Logging Block PS-007 ---
# --- Build Timestamp Filename ---

$now = Get-Date
$timestamp = $now.ToString("yyyy-0MM-0dd 0HH.0mm.0ss.fffffff")
$iana_tz = Get-IanaTimeZone
$iso_week_date = Get-IsoWeekDate -date $now
$iso_ordinal_date = Get-IsoOrdinalDate -date $now

# Get IP, hostname, and full username
$ip_address = $env:local_ipv4_address
$hostname = $env:COMPUTERNAME
$full_username = "$env:USERDOMAIN\$env:USERNAME" -replace '\\', ' backslash '

# Get PowerShell version
$powershell_version = $PSVersionTable.PSVersion.ToString()

# Compose filename
$log_name = "$timestamp $iana_tz $iso_week_date $iso_ordinal_date $ip_address $hostname $full_username Powershell $powershell_version"
$safe_log_name = $log_name -replace '/', ' slash '

$log_directory = "C:\terminal-logs\powershell-007-logs"
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