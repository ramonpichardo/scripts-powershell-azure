Set-ExecutionPolicy -Scope CurrentUser Bypass -Confirm:$false

# Log on to Azure tenant with your credentials
$credential = Get-Credential -Message "Log on to Azure with your username (e-mail address) and password"
Connect-AzAccount -Credential $credential

# List Azure VMs, sorted alphabetically by VM name
Get-AzVM -status | Sort-Object -Property Name | Select-Object Name,ResourceGroupName,
  @{Name="VmSize"; Expression={$_.HardwareProfile.VmSize}},
  @{Name="OsType"; Expression={$_.StorageProfile.OSDisk.OsType}} |
    Export-Csv -Path .\Azure_VMs.csv -NoTypeInformation

# Get count of Azure VMs
$n = Get-AzVM | Measure-Object
Write-Output "Total number of VMs in subscription '$($subscription)' is $($n.Count)."
