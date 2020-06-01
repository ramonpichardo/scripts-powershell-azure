<#
Source: https://www.360visibility.com/azure-accelerated-networking-and-how-to-enable-it/

What is Azure Accelerated Networking?
Azure Accelerated Networking is a new option for Azure Infrastructure as a Service (IaaS) Virtual Machine (VM) on the NIC level providing several benefits by enabling single root I/O virtualization (SR-IOV) to a VM, greatly improving its networking performance. This high-performance path bypasses the host from the datapath, reducing latency, jitter, and CPU utilization, for use with the most demanding network workloads on supported VM types. You would typically use this feature with heavy workloads that need to send or receive data at high speed with reliable streaming and lower CPU utilization. It will enable speeds of up to 25Gbps per Virtual Machine. Best of all, it’s free!

What are the Key Benefits?
- Lower latency/Higher Packets per Second: Removing the virtual switch from the datapath removes the time packets spend in the host for policy processing and increases the number of packets that can be processed inside the VM, enabling more data to be pushed at once.

- Reduced Jitter: Virtual switch processing depends on the amount of policy that needs to be applied and the workload of the CPU that is doing the processing. Offloading the policy enforcement to the hardware removes that variability by delivering packets directly to the VM, removing the host to VM communication and all software interrupts and context switches, which is better for streaming data.

- Decreased CPU Utilization: Bypassing the virtual switch in the host leads to less CPU utilization for processing network traffic, leaving more capacity for processing large amounts of data being sent or received.

Requirements:
It is currently available in all regions under most general purpose VM sizes that have 2 or more vCPUs. It is also available for most hyperthreading VMs with 4 or more vCPUs.

This feature can be enabled on VM creation or on an existing VM meeting criteria in the stopped state.

How to Enable Accelerated Networking:
You can enable this feature during initial creation of the VM, on the networking tab, you will see “Enable Accelerated Networking”. If you are unable to enable, then it is not compatible on your chosen Azure VM size. If you need to enable this feature after VM creation you will require to do so through powershell as it is not yet supported in the portal. You can do this simply with the below commands after deallocating the Virtual Machine.
Then proceed to start the Virtual Machine and Accelerated Networking will be enabled.
#>

Set-ExecutionPolicy -Scope CurrentUser Bypass -Confirm:$false

# Log on to Azure tenant and subscription with your credentials
$credential = Get-Credential -Message "Log on to Azure with your username (e-mail address) and password"
Connect-AzAccount -Credential $credential

# List all Azure subscriptions in the current tenant
Get-AzSubscription

# Set Azure subscription
$subscription = Read-Host -Prompt 'Input the Azure VM's subscription name'
$context      = Get-AzSubscription -SubscriptionName $subscription
Set-AzContext $context

# Enter VM details
$rgname  = Read-Host -Prompt 'Input the Azure VM's resource group name'
$nicname = Read-Host -Prompt 'Input the Azure VM's NIC name'
$vm      = Read-Host -Prompt 'Input the Azure VM's computer name'

# Stop the VM
Stop-AzVM -ResourceGroupName $rgname -Name $vm

# Enable Accelerated Networking
$nic = Get-AzNetworkInterface -ResourceGroupName $rgname -Name $nicname
$nic.EnableAcceleratedNetworking = $true
$nic | Set-AzNetworkInterface

# Start the VM
Start-AzVM -ResourceGroupName $rgname -Name $vm
