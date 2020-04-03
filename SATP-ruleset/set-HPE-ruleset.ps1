##############################################################################
# ./set-HPE-ruleset.ps1  -vCenter server1.domain.local
##############################################################################
##############################################################################
# Checking and making SATP Rules for HHPEPrimera Custom FC/FCoE ALUA Rule  #
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

$progress = 1
$esxList = Get-View -ViewType hostsystem -Property name | Sort-Object name

foreach ($esx in $esxList) {
 Write-Progress -Activity "Checking SATP rules" -Status "Working on $($esx.name)" -CurrentOperation "Getting EsxCli" -PercentComplete ($progress/$esxList.count*100)
 try {
 $EsxCli = Get-EsxCli -VMHost $esx.name
 }
 catch {
 $Error[0]
 Write-Host "Failed to get EsxCli, see above error" -ForegroundColor Red
 }
 
 Write-Progress -Activity "Checking SATP rules" -Status "Working on $($esx.name)" -CurrentOperation "Got EsxCli" -PercentComplete ($progress/$esxList.count*100)
 
 Write-Progress -Activity "Checking SATP rules" -Status "Working on $($esx.name)" -CurrentOperation "Checking if rule already is present" -PercentComplete ($progress/$esxList.count*100)
 if (!($EsxCli.storage.nmp.satp.rule.list() | Where-Object {$_.description -contains "HHPEPrimera Custom FC/FCoE ALUA Rule"})) {
 
 Write-Progress -Activity "Checking SATP rules" -Status "Working on $($esx.name)" -CurrentOperation "Creating rule" -PercentComplete ($progress/$esxList.count*100)
 try {
 $EsxCli.storage.nmp.satp.rule.add($null,"tpgs_on","HPEPrimera Custom FC/FCoE ALUA Rule",$null,$null,$null,"VV",$null,"VMW_PSP_RR","iops=1;policy=latency","VMW_SATP_ALUA",$null,$null,"3PARdata") | Out-Null
 }

catch {
 $Error[0]
 Write-Host "Rule creation failed on $($esx.name), see error above" -ForegroundColor Red
 }

Write-Host "Rule created on $($esx.name)" -ForegroundColor Green

}

else {
 Write-Host "Rule already exists, skipping" -ForegroundColor Yellow
 }
 
 $progress++
 }
