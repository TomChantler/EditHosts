# By Tom Chantler - https://tomssl.com/2019/04/30/a-better-way-to-add-and-remove-windows-hosts-file-entries/
param([string]$Hostname = "tomssl.local")
# Remove entry from hosts file. Removes all entries that match the hostname (i.e. both IPv4 and IPv6).
#Requires -RunAsAdministrator
$hostsFilePath = "$($Env:WinDir)\system32\Drivers\etc\hosts"
$hostsFile = Get-Content $hostsFilePath
Write-Host "About to remove $Hostname from hosts file" -ForegroundColor Gray
$escapedHostname = [Regex]::Escape($Hostname)
If (($hostsFile) -match ".*\s+$escapedHostname.*")  {
    Write-Host "$Hostname - removing from hosts file... " -ForegroundColor Yellow -NoNewline
    $hostsFile -notmatch ".*\s+$escapedHostname.*" | Out-File $hostsFilePath 
    Write-Host " done"
} 
Else {
    Write-Host "$Hostname - not in hosts file (perhaps already removed); nothing to do" -ForegroundColor DarkYellow
}