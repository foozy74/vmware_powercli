Description:
The script help you the report the Vmotion tasks

Dot source the both functions so they can be used
ie: period then a space and then the full or relative path to the function
. ./Get-VIEventPlus.ps1
. ./Get-VMotionHistory


.EXAMPLE

Get-Cluster -Name Cluster1 | Get-MotionHistory -Hours 24 -Recurse:$true
Get-Cluster -Name Cluster1 | Get-MotionHistory -Hours 24 -Recurse:$true | Export-Csv C:\PowerCLI\Output\vmotion-report1.csv -NoTypeINformation -UseCulture
