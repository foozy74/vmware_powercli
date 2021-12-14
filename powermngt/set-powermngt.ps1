Connect-VIServer
$VMHosts = Get-VMHost
#for each host change the power management policy to high performance
ForEach ($entry in $VMHosts) {
   $view=($entry | Get-View);(Get-View $view.ConfigManager.PowerSystem).ConfigurePowerPolicy(1)
   #list power management policy on all connected esxi hosts
   $entry | Select Name, @{ N="CurrentPolicy"; E={$_.ExtensionData.Config.PowerSystemInfo.CurrentPolicy.ShortName}},@{N="CurrenPolicyKey"; E={$_.ExtensionData.Config.PowerSystemInfo.CurrentPolicy.Key}},@{N="AvailablePolicies";E={$_.ExtensionData.Config.PowerSystemCapability.AvailablePolicy.ShortName}}
}
disconnect-Viserver *
