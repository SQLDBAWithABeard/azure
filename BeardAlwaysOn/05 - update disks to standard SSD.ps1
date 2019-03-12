Connect-AzAccount
# resource group that contains the managed disk
$rgName = 'BeardAlwaysOn2017'
# Choose between Standard_LRS and StandardSSD_LRS based on your scenario
$storageType = 'StandardSSD_LRS'

$disks = Get-AzDisk -ResourceGroupName $rgName

foreach ($disk in $Disks) {
    $msg = "Disk $($disk.Name)"
    Write-PSFMessage -Message $msg -Level Significant
    $skuName = $disk.sku.name 
    # Get parent VM resource
    $vmResource = Get-AzResource -ResourceId $disk.ManagedBy
    $msg = "Disk $($disk.Name) on VM - $($vmResource.Name)"
    Write-PSFMessage -Message $msg -Level Significant
    switch ($skuName) {
        'Standard_LRS' { 
            $msg = "Disk $($disk.Name) on VM - $($vmResource.Name) is already Standard_LRS"
            Write-PSFMessage -Message $msg -Level Significant
        }
        'StandardSSD_LRS' { 
            $msg = "Disk $($disk.Name) on VM - $($vmResource.Name) is already StandardSSD_LRS"
            Write-PSFMessage -Message $msg -Level Significant
        }
        Default {

            $msg = "Working on VM - $($vmResource.Name)"
            Write-PSFMessage -Message $msg -Level Significant
 
            $msg = "Stopping VM - $($vmResource.Name)"
            Write-PSFMessage -Message $msg -Level Significant
 
            # Stop and deallocate the VM before changing the storage type
            Stop-AzVM -ResourceGroupName $vmResource.ResourceGroupName -Name $vmResource.Name -Force
 
            $vm = Get-AzVM -ResourceGroupName $vmResource.ResourceGroupName -Name $vmResource.Name 
 
            $msg = "Updating disk $($disk.Name) on VM - $($vmResource.Name)"
            Write-PSFMessage -Message $msg -Level Significant
 
            # Update the storage type
            $diskUpdateConfig = New-AzDiskUpdateConfig -AccountType $storageType -DiskSizeGB $disk.DiskSizeGB
            Update-AzDisk -DiskUpdate $diskUpdateConfig -ResourceGroupName $rgName -DiskName $disk.Name
 
            $msg = "Finished disk $($disk.Name) on VM - $($vmResource.Name)"
            Write-PSFMessage -Message $msg -Level Significant
        }
    }


    # Start-AzVM -ResourceGroupName $vm.ResourceGroupName -Name $vm.Name
}
