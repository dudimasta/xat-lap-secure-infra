//param nic_name string = 'test-access-vm908'
param nic_name string
param publicIpAddress_name string
param vnet_name string
param subnet_name string
param nsg_name string

// look for nsg to associate NIC with
resource linux_vm_nsg_resource 'Microsoft.Network/networkSecurityGroups@2023-11-01' existing = {
  name: nsg_name
  scope: resourceGroup()
}

resource linux_vm_ip_address_resource 'Microsoft.Network/publicIPAddresses@2023-11-01' existing = {
  name: publicIpAddress_name
  scope: resourceGroup()
}

resource linux_vm_vnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: vnet_name
  scope: resourceGroup()
}

// look for subnet id where nic will be associated
resource linux_vm_nic_subnet_resource 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  name: subnet_name
  parent: linux_vm_vnet
}

resource nic_name_resource 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: nic_name
  location: resourceGroup().location
#disable-next-line BCP187
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: linux_vm_ip_address_resource.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: linux_vm_nic_subnet_resource.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }

      }
      
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
    
    networkSecurityGroup: {
      id: linux_vm_nsg_resource.id
    }
  
  }
  dependsOn: [
    linux_vm_ip_address_resource
    linux_vm_nic_subnet_resource
    linux_vm_nsg_resource
  ]
}
