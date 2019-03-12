## turn on the machines in the BeardAlwayson 2017 Rg

Connect-AzAccount

$RG = 'BeardAlwaysOn2017'

$vms = Get-AzVM -ResourceGroupName $rg -Status
$vms


if($ENV:COMPUTERNAME -eq 'Rob-XPS'){
    cd GIT:\Azure\BeardAlwaysOn
}
elseif($ENV:COMPUTERNAME -eq 'BEARDNUC'){
   cd  D:\OneDrive\Documents\GitHub\Azure\BeardAlwaysOn
}


. .\Invoke-Parallel.ps1

<#
    foreach ($vm in $vms) {
        if ($vm.PowerState -ne 'VM Running') {
            $status = Start-AzureRmVM -Name $vm.Name -ResourceGroupName $RG
            if ($Status.Status -eq 'Succeeded') {
                Write-Output "Started $($Vm.Name)"
            }
            else {
                Write-Warning "Failed to start $($VM.Name)"
            }
        }
        else {
            Write-Output "$($VM.Name) was alrady running"
        }
    }
#>

$scriptBlock = {    if ($psitem.PowerState -ne 'VM Running') {
        $status = Start-AzVM -Name $psitem.Name -ResourceGroupName $RG
        if ($Status.Status -eq 'Succeeded') {
            Write-Host "Started $($psitem.Name)" -ForegroundColor Green
        }
        else {
            Write-Warning "Failed to start $($psitem.Name) - Status was $($Status.Status)"
            $Status
        }
    }
    else {
        Write-Host "$($psitem.Name) was already running" -ForegroundColor Green
    }
}

$Vms | Invoke-Parallel -ImportVariables -ScriptBlock $ScriptBlock

#Download the RDP for the jump box and open

Get-AzRemoteDesktopFile -ResourceGroupName $rg -Name JumpBox -Launch


Get-AzRemoteDesktopFile -ResourceGroupName $rg -Name bearddockerhost -Launch



 