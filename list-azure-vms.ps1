Set-ExecutionPolicy -Scope CurrentUser Bypass -Confirm:$false

# Log on to Azure tenant with your credentials
$credential = Get-Credential -Message "Log on to Azure with your username (e-mail address) and password"
Connect-AzAccount -Credential $credential

# List all Azure subscriptions in the current tenant
Get-AzSubscription

# Set Azure subscription
$subscription = Read-Host -Prompt 'Input the Azure subscription name to be queried'
$context = Get-AzSubscription -SubscriptionName $subscription
Set-AzContext $context

# List Azure VMs, sorted alphabetically by VM name
Get-AzVM -status | Sort-Object -Property Name | Select-Object Name,ResourceGroupName,
  @{Name="VmSize"; Expression={$_.HardwareProfile.VmSize}},
  @{Name="OsType"; Expression={$_.StorageProfile.OSDisk.OsType}} |
    Export-Csv -Path .\Azure_VMs.csv -NoTypeInformation

# Get count of Azure VMs
$n = Get-AzVM | Measure-Object
Write-Host "Total number of VMs in subscription '$($subscription)' is $($n.Count)." -ForegroundColor red -BackgroundColor white

# Get count of running VMs in subscription
$n = Get-AzVM -status | Sort-Object -Property Name | Where-Object -FilterScript { $_.PowerState -eq "VM running" } | Select-Object Name,ResourceGroupName, @{ label = "Status"; Expression = { $_.PowerState } } | Measure-Object;
Write-Host "Total number of running VMs in subscription '$($subscription)' is $($n.Count)." -ForegroundColor red -BackgroundColor white

# Get count of stopped deallocated VMs in subscription
$n = Get-AzVM -status | Sort-Object -Property Name | Where-Object -FilterScript { $_.PowerState -eq "VM deallocated" } | Select-Object Name,ResourceGroupName, @{ label = "Status"; Expression = { $_.PowerState } } | Measure-Object;
Write-Host "Total number of stopped deallocated VMs in subscription '$($subscription)' is $($n.Count)." -ForegroundColor red -BackgroundColor white
