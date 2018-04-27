<#

This will take the computer it runs on and change the IP address, Default Gateway, and computer name.

Tested with only 1 NIC

#>

# VARIABLES #
$ipaddress = "192.168.110.50"   # ip address
$ipprefix = "24"                # subnet
$ipg = "192.168.110.1"          # default gateway
$dnsip = ("192.168.110.1", "1.1.1.1") # DNS addresses
$newname = "DC-01"              # new computer name
$logpath = "C:\log\log.txt"


# check if log folder exists
if(!(Test-Path $logpath)){    New-item -ItemType File -Path $logpath -ErrorAction Ignore -Force }

# change ip address
$ipif=(Get-NetAdapter).ifindex
New-NetIPAddress -IPAddress $ipaddress -PrefixLength $ipprefix -interfaceindex $ipif -DefaultGateway $ipg

# set DNS address
Set-DnsClientServerAddress -InterfaceIndex $ipif -ServerAddresses $dnsip

# Restart after computer change
Rename-Computer -NewName $newname -Force -restart