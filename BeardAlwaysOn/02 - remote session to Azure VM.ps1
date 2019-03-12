#  $cred = Get-Credential
Write-Output "Creating PSSession"
$so = New-PsSessionOption -SkipCACheck -SkipCNCheck
$session = New-PSSession -ComputerName beardjumpbox.westeurope.cloudapp.azure.com -Credential $cred -UseSSL -SessionOption $so 