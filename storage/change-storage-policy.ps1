
Get-VMHost | Get-ScsiLun -LunType disk | Where {$_.MultipathPolicy -notlike "RoundRobin"}

Get-VMHost | Get-ScsiLun -LunType disk | Where {$_.MultipathPolicy -notlike "RoundRobin"} | Where {$_.CapacityGB -ge 100}

Get-VMHost | Get-ScsiLun -LunType disk | Where {$_.MultipathPolicy -notlike "RoundRobin"} | Where {$_.CapacityGB -ge 100} | Set-Scsilun -MultiPathPolicy RoundRobin


