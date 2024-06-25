//param publicIPAddresses_test_access_vm_ip_name string = 'test-access-vm-ip'
param linux_vm_ip_address_name string

resource publicIPAddresses_test_access_vm_ip_name_resource 'Microsoft.Network/publicIPAddresses@2023-11-01' = {
  name: linux_vm_ip_address_name
  location: resourceGroup().location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    //ipAddress: '13.79.233.197'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    ipTags: []
  }
}
