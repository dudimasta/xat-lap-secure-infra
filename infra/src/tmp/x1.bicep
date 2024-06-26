param networkInterfaces_foo1_name string = 'foo6'
param virtualNetworks_sec_wf_vnet_externalid string = '/subscriptions/872d7f5d-34ce-4fd2-aad8-4259b54f3aa6/resourceGroups/sec-wf-access-rg/providers/Microsoft.Network/virtualNetworks/sec-wf-vnet'
param nsg_id string = '/subscriptions/872d7f5d-34ce-4fd2-aad8-4259b54f3aa6/resourceGroups/sec-wf-access-rg/providers/Microsoft.Network/networkSecurityGroups/sec-wf-linux-nsg'
param publicIpAddress_Id string = '/subscriptions/872d7f5d-34ce-4fd2-aad8-4259b54f3aa6/resourceGroups/sec-wf-access-rg/providers/Microsoft.Network/publicIPAddresses/sec-wf-linux-vm-ip-addr'

resource networkInterfaces_foo1_name_resource 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: networkInterfaces_foo1_name
  location: 'northeurope'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'Ipv4config'
        type: 'Microsoft.Network/networkInterfaces/ipConfigurations'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIpAddress_Id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: '${virtualNetworks_sec_wf_vnet_externalid}/subnets/sec-wf-default-snet'
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
      id: nsg_id
    }
  }
}
