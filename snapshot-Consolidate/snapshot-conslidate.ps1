Get-VM |
Where-Object {$_.Extensiondata.Runtime.ConsolidationNeeded} |
ForEach-Object {
.ExtensionData.ConsolidateVMDisks_Task()
}
