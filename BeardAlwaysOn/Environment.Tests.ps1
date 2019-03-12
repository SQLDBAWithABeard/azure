# Login-AzureRmAccount

# Select-AzureRmSubscription 'Microsoft Azure Sponsorship'

$RG = 'BeardAlwaysOn2017'
Describe "Checking Resource Group BeardAlwaysOn2017" {
    Context "Checking Virtual Machines" {
        $vms = Get-AzureRmVM -ResourceGroupName $rg -Status
        foreach ($vm in $vms) {
            It "Virtual Machine $($VM.Name) should be running" {
                $VM.PowerState | Should -Be "VM Running" -Because "We expect the machine to be running"
            }
        }
    }
}