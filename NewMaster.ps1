
### Subscription
[String]$Sub_Id=Read-Host -Prompt "Please Enter Subscription Id"
Write-Host "Execution Started $Date"  -ForegroundColor Yellow

### Sub
Select-AzSubscription -Subscription $Sub_Id | Out-Null
$Sub_Context_Name=(Get-AzContext).Subscription | Select -ExpandProperty Name
$Sub_Context_Id=(Get-AzContext).Subscription | Select -ExpandProperty Id
Write-Host "Selected Sub $Sub_Context_Name" -ForegroundColor Yellow

### Child Script Location
###[String]$ChildScriptPath=Read-Host -Prompt "Enter Child Script Path like e.g. D:\FolderName\childscript.ps1"
$ChildScriptPath=""
Write-Host "Selected ChildScriptPath Path $ChildScriptPath" -ForegroundColor Yellow

### VMs
$VMS=Get-AzVM
$VM_Count=$VMS.Count
Write-Host "VMs Count $VM_Count"


for($i=0;$i -lt $VM_Count ; $i++)
{
###
$ProcessingCount1=$i+1
$RemainingCount1=$VM_Count-$ProcessingCount1
Write-Host "Processing VMs $ProcessingCount1 | Remaining VMs $RemainingCount1" -ForegroundColor Yellow
###
$VMdetails=$VMS[$i]
$vmname = $VMdetails.Name
$rgname = $VMdetails.ResourceGroupName
$location = $VMdetails.Location
$vmname
$rgname
Write-Host "Working on VM $vmname"

Invoke-AzVMRunCommand -ResourceGroupName $rgname -VMName $vmname -CommandId RunPowerShellScript -AsJob -ScriptPath $ChildScriptPath -Verbose -ErrorAction SilentlyContinue

}


Write-Host "Execution Complete $Date"  -ForegroundColor Yellow