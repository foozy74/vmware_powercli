##############################################################################
# ./set-advanced.ps1  -vCenter server1.domain.local -Clusters cluster1 
##############################################################################
##############################################################################
# change storage Settings for HPE Storage #
##############################################################################

Param (
	[Parameter(Mandatory=$true)][string]$vCenter,
	[Parameter(Mandatory=$true)][String]$username,
	[Parameter(Mandatory=$true)][String]$password,
	[Parameter(Mandatory=$true)][String]$Cluster)
  
### Start of Script
# Load VMware Cmdletdi
Import-Module VMware.PowerCLI

#  connect to vCenter
Connect-VIServer -Server $vcenter -User $username -Password $password

# query the Cluster
$VMHost = Get-Cluster -Name $Cluster | Get-VMhost
  
# QFullSampleSize
ForEach ($VMhost in $Cluster){
    Write-Host -ForegroundColor GREEN "Setting QFullSampleSize " -NoNewline
    Write-Host -ForegroundColor YELLOW "$VMhost"
    Get-VMhost | Get-AdvancedSetting | Where {$_.Name -eq "Disk.QFullSampleSize"} | Set-AdvancedSetting -Value "32" -Confirm:$false
    }
# QFullThreshold
ForEach ($VMhost in $Cluster){
    Write-Host -ForegroundColor GREEN "Setting QFullThreshold " -NoNewline
    Write-Host -ForegroundColor YELLOW "$VMhost"
    Get-VMhost | Get-AdvancedSetting | Where {$_.Name -eq "Disk.QFullThreshold"} | Set-AdvancedSetting -Value "8" -Confirm:$false
    }

#  disconnect from vCenter
Disconnect-VIServer -Server * -Force -confirm:$false
