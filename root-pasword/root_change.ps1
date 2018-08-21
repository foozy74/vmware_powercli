function Load_PowerCLI ()
 {
Get-Module -Name VMware* -ListAvailable | Import-Module
 }
 
function change_pw ()
{
#AD User for Login to esxi hosts
 clear
 [console]::ForegroundColor = "yellow"
 [console]::BackgroundColor= "black"
 [string]$global:aduser=Read-Host "AD User as example:p_user@production.local"
 [string]$global:adpw=Read-Host "password"

#esxi host and password list
  clear
 [console]::ForegroundColor = "green"
 [console]::BackgroundColor= "black"
 [string]$global:sourceCSV=Read-Host "Please enter Path and File Name [C:\Scripts\server.csv]"
 
#Starts a transcript of the script output
Start-Transcript -path "c:\pw-change-log.txt"

#Gets a list of hosts to change passwords for, make sure there is no break after the last host
$vihosts = Import-CSV $sourceCSV

#Starts Error Report recording
$errReport =@()

#Starts the process and loops until the last host in the host.txt file is reached
foreach ($line in $vihosts){

	#Connects to each host from the hosts.txt list and also continues on any error to finish the list
	Connect-VIServer $line.server -User $aduser -Password $adpw -ErrorAction SilentlyContinue -ErrorVariable err
	
	
	$errReport += $err
	if($err.Count -eq 0){
	#Sets the root password
	Set-VMHostAccount -UserAccount root -Password $line.password
	}
	
	#Disconnects from each server and suppresses the confirmation
	Disconnect-VIServer -Confirm:$False
	$errReport += $err
	$err = ""
}

#Outputs the error report to a CSV file, if file is empty then no errors.
$errReport | Export-Csv ".\Pass-HostReport.csv" -NoTypeInformation

#Stops the transcript
Stop-Transcript
}

Load_PowerCli
change_pw