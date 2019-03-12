if($ENV:COMPUTERNAME -eq 'Rob-XPS'){
    cd GIT:\Azure\BeardAlwaysOn
}
elseif($ENV:COMPUTERNAME -eq 'BEARDNUC'){
   cd  D:\OneDrive\Documents\GitHub\Azure\BeardAlwaysOn
}


. .\Invoke-Parallel.ps1

Select-AzureRmSubscription 'Microsoft Azure Sponsorship'

$RG = 'BeardAlwaysOn2017'

$vms = Get-AzureRmVM -ResourceGroupName $RG -Status 
$vms

$scriptblock = {
    Stop-AzureRmVM -ResourceGroupName $rg -Name $psitem.Name -Force
    Write-Output "Shut Down $($psitem.Name)"
}

$Vms | Invoke-Parallel -ImportVariables -ScriptBlock $ScriptBlock 