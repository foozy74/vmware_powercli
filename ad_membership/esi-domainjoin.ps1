##################################################
# ./esi-domainjoin.ps1  -vCenter server1.domain.local -vuser vcenter@username -vpassw password -Clusters cluster1,cluster2 -Domain domain.local/Servers/ESXi -User user01 -Password Password01joi 
##################################################

Param (
  [Parameter(Mandatory=$false)][string] $vCenter,
  [Parameter(Mandatory=$true)][string] $vuser,
  [Parameter(Mandatory=$true)][string] $vpassw,
	[Parameter(Mandatory=$false)][String[]] $Clusters,
	[Parameter(Mandatory=$false)][string] $Domain,
	[Parameter(Mandatory=$false)][string] $User,
	[Parameter(Mandatory=$false)][string] $Password)
  
### Start of Script
# Load VMware Cmdlet
Import-Module VMware.PowerCLI

#  connect to vCenter
Connect-VIServer -Server $vCenter -User $vuser -User $vpassw
ForEach ($Cluster in $Clusters)
    { 
    $VMHosts = Get-Cluster $Cluster | Get-VMHost
	
ForEach ($VMHost in $VMHosts)
     { 
     Get-VMHostAuthentication -VMHost $VMHost.Name | Set-VMHostAuthentication -JoinDomain -Domain $Domain -User $User -Password $Password -Confirm:$False
     } 
	 
} 

#  disconnect from vCenter
Disconnect-VIServer -Server * -Force -confirm:$false

### End of Script
