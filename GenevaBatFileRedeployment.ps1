Start-Transcript -Path "C:\GenevaAgent\transcript0.txt" -Force
cd C:\GenevaAgent
Write-Host "Execution Started $Date"  -ForegroundColor Yellow
Remove-Item ".\LaunchAgent.bat" -Verbose
$url1 = "https://corestorageoeahq.blob.core.windows.net/share/LaunchAgent.txt"
$output1 = "C:\GenevaAgent\LaunchAgent.bat"
Import-Module BitsTransfer
Start-BitsTransfer -Source $url1 -Destination $output1

#####
SCHTASKS /Run /TN \GenevaMonitoringAgent
Start-Sleep -Seconds 600

#####
### Validation
#####
$MonCore=Get-Process -Name "MonAgentCore" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | select -ExpandProperty Id
$MonManager=Get-Process -Name "MonAgentManager" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | select -ExpandProperty Id
$MonHost=Get-Process -Name "MonAgentHost" -ErrorAction SilentlyContinue -WarningAction SilentlyContinue | select -ExpandProperty Id

#####
if($MonCore -ne $null){Write-Host "MonAgentCore Process is Running" -ForegroundColor Green}else{
Write-Host "######## MonAgentCore Process is Not Running ########" -ForegroundColor Red}

if($MonManager -ne $null){Write-Host "MonAgentManager Process is Running" -ForegroundColor Green}else{
Write-Host "######## MonAgentManager Process is Not Running ########" -ForegroundColor Red}

if($MonHost -ne $null){Write-Host "MonAgentHost Process is Running" -ForegroundColor Green}else{
Write-Host "######## MonAgentHost Process is Not Running ########" -ForegroundColor Red}



#####
Write-Host "Execution Complete $Date"  -ForegroundColor Yellow
Stop-Transcript
$Message=gc "C:\GenevaAgent\transcript0.txt"
Write-EventLog -LogName "System" -source "Service Control Manager" -EntryType Information -EventId "65111" -Message "$Message" -Verbose
