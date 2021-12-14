Connect-VIServer
$VMHosts = Get-VMHost
#for each host show the power management policy setting
ForEach ($entry in $VMHosts) {
   #list power management policy on all connected esxi hosts
   $entry | Select Name, @{ N="CurrentPolicy"; E={$_.ExtensionData.Config.PowerSystemInfo.CurrentPolicy.ShortName}},@{N="CurrenPolicyKey"; E={$_.ExtensionData.Config.PowerSystemInfo.CurrentPolicy.Key}},@{N="AvailablePolicies";E={$_.ExtensionData.Config.PowerSystemCapability.AvailablePolicy.ShortName}}
}
disConnect-VIServer *
