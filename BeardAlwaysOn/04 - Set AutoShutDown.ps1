CD GIT:\Azure\BeardAlwaysOn\

. ./Set-AzureRmVMAutoShutdown.ps1

# Set to 22:00

$VMs.ForEach{
    Set-AzureRmVMAutoShutdown -ResourceGroupName $RG -Name $Psitem.Name -Enable -Time 22:00 
}
# Set back to 19:00
$VMs.ForEach{
    Set-AzureRmVMAutoShutdown -ResourceGroupName $RG -Name $Psitem.Name -Enable -Time 19:00 
}