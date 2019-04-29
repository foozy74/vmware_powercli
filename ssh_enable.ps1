##################################################
# ./ssh_enable.ps1  -vCenter server1.domain.local -Clusters cluster1,cluster2 
##################################################
#####################################################################
# Start SSH Service, change Startup Policy, and Suppress SSH Warning #
######################################################################

Param (
	[Parameter(Mandatory=$true)][string]$vCenter,
	[Parameter(Mandatory=$true)][String]$username,
	[Parameter(Mandatory=$true)][String]$password,
	[Parameter(Mandatory=$true)][String] $Cluster)

# Variables or you use fix parameter
# $vCenter = "LABVC01.virtuallyboring.com"
# $Cluster = "Nested ESXi Cluster"
  
### Start of Script
# Load VMware Cmdlet
Import-Module VMware.PowerCLI

#  connect to vCenter
Connect-VIServer -Server $vcenter -User $username -Password $password

# query the Cluster
$VMHost = Get-Cluster -Name $Cluster | Get-VMhost
  
# Start SSH Server on a Cluster
ForEach ($VMhost in $Cluster){
Write-Host -ForegroundColor GREEN "Starting SSH Service on " -NoNewline
Write-Host -ForegroundColor YELLOW "$VMhost"
Get-VMHost | Get-VMHostService | ? {($_.Key -eq "TSM-ssh") -and ($_.Running -eq $False)} | Start-VMHostService
}
  
# Change Startup Policy
ForEach ($VMhost in $Cluster){
Write-Host -ForegroundColor GREEN "Setting Startup Policy on " -NoNewline
Write-Host -ForegroundColor YELLOW "$VMhost"
Get-VMHost | Get-VMHostService | where { $_.key -eq "TSM-SSH" } | Set-VMHostService -Policy "On" -Confirm:$false -ea 1
}
  
# Surpress SSH Warning
ForEach ($VMhost in $Cluster){
Write-Host -ForegroundColor GREEN "Setting UserVar to supress Shell warning on " -NoNewline
Write-Host -ForegroundColor YELLOW "$VMhost"
Get-VMhost | Get-AdvancedSetting | Where {$_.Name -eq "UserVars.SuppressShellWarning"} | Set-AdvancedSetting -Value "1" -Confirm:$false
}

#  disconnect from vCenter
Disconnect-VIServer -Server * -Force -confirm:$false

### End of Script