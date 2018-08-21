Write-Verbose "Getting list of Old Snapshots"

function Load_PowerCLI ()
  {
Get-Module -Name VMware* -ListAvailable | Import-Module
 }


 
function vCenter_Connect ()
 {
 clear
 [console]::ForegroundColor = "yellow"
 [console]::BackgroundColor= "black"
 [string]$global:sourceVI=Read-Host "Please enter vCenter Server [Ip/FQDN] : "
 $source_credentials = Get-Credential
 Connect-VIServer $sourceVI -credential $source_credentials
 [console]::ResetColor()
 }

function disconnect_vcenter ()
 {
 Disconnect-VIServer -Server * -Force -confirm:$false
 }

function unload_PowerCLI ()
 {
 Remove-PSSnapin VMware.VimAutomation.Core
 }
 

function snapshot ()
 {
$OldSnapshotList = Get-VM | get-snapshot

    IF ($OldSnapshotList -ne $null)

        {

        Write-Verbose "Getting Additional Snapshot Details"

        #Open report array

        $Report = @()

        $SnapUser = ""

 

        FOREACH ($Snapshot in $OldSnapshotList)

            {

            #Use Task log SDK to get the user who created the Snapshot

            $TaskMgr = Get-View TaskManager

            $TaskNumber = 100

 

            #Create task filter for search

            $Filter = New-Object VMware.Vim.TaskFilterSpec

            $Filter.Time = New-Object VMware.Vim.TaskFilterSpecByTime

            $Filter.Time.beginTime = ((($Snapshot.Created).AddSeconds(-5)).ToUniversalTime())

            $Filter.Time.timeType = "startedTime"

            $Filter.Time.EndTime = ((($Snapshot.Created).AddSeconds(5)).ToUniversalTime())

            $Filter.State = "success"

            $Filter.Entity = New-Object VMware.Vim.TaskFilterSpecByEntity

            $Filter.Entity.recursion = "self"

            $Filter.Entity.entity = (Get-Vm -Name $Snapshot.VM.Name).Extensiondata.MoRef

 

            $TaskCollector = Get-View ($TaskMgr.CreateCollectorForTasks($Filter))

            $TaskCollector.RewindCollector | Out-Null

            $Tasks = $TaskCollector.ReadNextTasks($TaskNumber)

                #Get only the task for the snapshot in question and out put the username of the snapshot creator

                FOREACH ($Task in $Tasks)

                    {

                    $GuestName = $Snapshot.VM

                    $Task = $Task | where {$_.DescriptionId -eq "VirtualMachine.createSnapshot" -and $_.State -eq "success" -and $_.EntityName -eq $GuestName}                        

                    IF ($Task -ne $null)

                        {

                        $SnapUser = $Task

                        }

                    $TaskCollector.ReadNextTasks($TaskNumber)

                    }

                #Create a custom object for reporting

                $objReport = New-Object System.Object

  $objReport | Add-Member -Type NoteProperty -Name "Snapshot Name" -Value $Snapshot.Name

                $objReport | Add-Member -Type NoteProperty -Name "Description" -Value $Snapshot.Description               

                $objReport | Add-Member -Type NoteProperty -Name "Created By" -Value $SnapUser.Reason.Username

                $objReport | Add-Member -Type NoteProperty -Name "Attached To" -Value $Snapshot.VM

                $objReport | Add-Member -Type NoteProperty -Name "Created On" -Value $Snapshot.Created

                $Report += $objReport

            #There is a default limit of 32 collector objects, destroying collector after use

            $TaskCollector.DestroyCollector()

 

            }

  }

  $report 
 }
  
Load_PowerCLI
vCenter_Connect
snapshot   
disconnect_vcenter
unload_PowerCLI