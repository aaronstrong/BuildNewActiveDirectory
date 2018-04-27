<#

Installs DHCP Server role and activites in Active Directory

Creates a single scope

#>

# VARIABLES #
# Configure Scopes #
$scopename = "Corpnet"
$startip = "192.168.110.100"
$endip = "192.168.110.150"
$mask = "255.255.255.0"
$gateway = "192.168.110.1"
# Domain Information #
$dnsip = "192.168.110.50"
$domain = "$env:USERDNSDOMAIN"
$domainip = "192.168.110.50"
$logpath = "C:\log\log.txt"

# check if log folder exists
if(!(Test-Path $logpath)){    New-item -ItemType File -Path $logpath -ErrorAction Ignore -Force }

# install Windows Feature
Install-WindowsFeature DHCP -IncludeManagementTools >> $logpath

# Create DHCP Security Groups
netsh dhcp add securitygroups

# Restart DHCP service
Restart-service dhcpserver

# Authorize DHCP server in Active Director
Add-DhcpServerInDC -dnsname $domain -ipaddress $domainip >> $logpath

# Verify DHCP is authorized
Get-dhcpserverindc  >> $logpath

# Configure Scopes
Add-DhcpServerv4Scope -name $scopename -StartRange $startip -EndRange $endip -SubnetMask $mask -State Active

# Set Default Gateway
$scopeID = Get-DhcpServerv4Scope
Set-DhcpServerv4OptionValue -OptionID 3 -Value $gateway -ScopeID $scopeID.ScopeId >> $logpath

# Set DNS
Set-DhcpServerv4OptionValue -OptionId 6 -Value $dnsip -ScopeId $scopeID.ScopeId >> $logpath