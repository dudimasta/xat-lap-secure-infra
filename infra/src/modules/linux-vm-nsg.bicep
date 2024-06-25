//param networkSecurityGroups_test_access_vm_nsg_name string = 'test-access-vm-nsg'
param linux_vm_nsg_name string

resource linux_vm_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2023-11-01' = {
  name: linux_vm_nsg_name
  location: resourceGroup().location
  properties: {}
}

resource networkSecurity__resource_SSH 'Microsoft.Network/networkSecurityGroups/securityRules@2023-11-01' = {
  parent: linux_vm_nsg_name_resource
  name: 'SSH'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '22'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
}
