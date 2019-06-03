# How to run this script
# PS C:\Users\ramon\Desktop> & '.\delete-empty-resource-groups.ps1'

# Log on to your Azure account
Connect-AzAccount

# Get list of Azure subscriptions
$Subs = (get-AzSubscription).ID

# Search each subscription one at a time to find and then store all empty resource groups in $EmptyRGs
ForEach ($sub in $Subs) {
Select-AzSubscription -SubscriptionId $Sub
$AllRGs = (Get-AzResourceGroup).ResourceGroupName
$UsedRGs = (Get-AzResource | Group-Object ResourceGroupName).Name
$EmptyRGs = $AllRGs | Where-Object {$_ -notin $UsedRGs}

# For each empty resource group confirm whether or not to delete.
ForEach ($EmptyRG in $EmptyRGs){
$Confirmation = Read-Host "Would you like to delete $EmptyRG '(Y)es' or '(N)o'"
IF ($Confirmation -eq "y" -or $Confirmation -eq "Yes"){
Write-Host "Deleting" $EmptyRG "Resource Group"
Remove-AzResourceGroup -Name $EmptyRG -Force
}
}
}
