<#

This will take the computer it runs on and change the IP address, Default Gateway,
and computer name

#>

$ipaddress = "192.168.110.50"
$ipprefix = "24"
$ipg = "192.168.110.1"

$ipif=(Get-NetAdapter).ifindex
New-NetIPAddress -IPAddress $ipaddress -PrefixLength $ipprefix -interfaceindex $ipif -DefaultGateway $ipg

# Rename Computer
$newname = "DC-01"

Rename-Computer -ComputerName $newname -Force

# Install Features
$featureLogPath = "C:\log\featurelog.txt"
New-Item $featureLogPath -ItemType file -Force

$addTools = "RSAT-AD-TOOLS"

Add-WindowsFeature $addTools

Get-WindowsFeature | Where-Object Installed >> $featureLogPath

Restart-Computer