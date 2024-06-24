targetScope='subscription'

resource resourceGroup_access 'Microsoft.Resources/resourceGroups@2024-03-01' existing = {
  name: 'sec-wf-access-rg'
}

param linux_vm_nic_subnet string = 'sec-wf-snet-2'
resource linux_vm_nic_subnet_resource 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  parent: 
  name: linux_vm_nic_subnet
  scope: resourceGroup_access
}

//resource 
