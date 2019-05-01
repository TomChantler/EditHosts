# By Tom Chantler - https://tomssl.com/2019/04/30/a-better-way-to-add-and-remove-windows-hosts-file-entries/
[CmdletBinding(SupportsShouldProcess=$true)]
param([string[]]$ServerList,
[int]$TimeOut=5)
# Copy local hosts files to multiple computers, overwriting the existing hosts files. Backs up existing hosts file to hosts.bak
#Requires -RunAsAdministrator
$numberOfServers = $ServerList.Length

If ($PSCmdlet.ShouldProcess($null)){
    # Only read the local hosts file if we're actually going to do anything
    $newHostsFileContent = Get-Content "$($Env:WinDir)\system32\Drivers\etc\hosts"
    Write-Host "I'm going to copy the local hosts file to $numberOfServers servers"
}

ForEach ($server in $ServerList){
    $path = "\\$server\C$\Windows\System32\drivers\etc\hosts" # Make sure to point to the correct drive for your windows directory or change this to use a proper UNC share.
	$remoteEtcDirectory = Split-Path $path
    If ($PSCmdlet.ShouldProcess($path, "Copy local hosts file to target location")) {
        $destination = @{Object = $path; ForegroundColor = 'Yellow';}
        $canGetHostsFileResult = $path | Start-Job { Get-Item } | Wait-Job -Timeout $TimeOut
        If ($canGetHostsFileResult) {
            # Make a backup of the remote hosts file
            Copy-Item $path -Destination $remoteEtcDirectory\hosts.bak
            # Write the local host file to the remote server
            $newHostsFileContent | Out-File $path #Note that Out-File respects the -WhatIf parameter.
            Write-Host "New hosts file written to " -NoNewLine 
            Write-Host @destination
        } 
        Else {
            Write-Host "Couldn't access file at " -NoNewLine -ForegroundColor Red 
            Write-Host @destination
        }
    }
}

Write-Host "Done!"