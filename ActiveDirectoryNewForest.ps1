<#

Create new forest with the parameters defined under Variables

#>
# Variables
$domainName = "contoso.local"
$netbiosName = "contoso"
$safeModeAdminstratorPassword = ConvertTo-SecureString 'VMware1!' -AsPlainText -Force
$featureLogPath = "C:\log\featurelog.txt"
$domainMode = "Win2012R2"
$forestMode = "Win2012R2"

New-Item $featureLogPath -ItemType file -Force

# Install Active Directory Roles
Start-Job -Name addfeature -ScriptBlock {
Add-WindowsFeature -Name "ad-domain-services" -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name "dns" -IncludeAllSubFeature -IncludeManagementTools
Add-WindowsFeature -Name "gpmc" -IncludeAllSubFeature -IncludeManagementTools
}
Wait-Job -Name addfeature

Get-WindowsFeature | Where-Object installed >> $featureLogPath

# Install new Active Directory Forest

Import-Module ADDSDeployment

Install-ADDSForest `
-CreateDnsDelegation:$false  `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode $domainMode -ForestMode $forestMode `
-DomainName $domainName `
-DomainNetbiosName $netbiosname `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-SafeModeAdministratorPassword $safeModeAdminstratorPassword `
-Force:$true