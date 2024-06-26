param privateDnsZones_privatelink_file_core_windows_net_name string = 'privatelink.file.core.windows.net'
param virtualNetworks_sec_wf_lap_vnet_externalid string = '/subscriptions/de47847e-1e04-4c18-99de-a11f659d3119/resourceGroups/sec-wf-workflow-rg/providers/Microsoft.Network/virtualNetworks/sec-wf-lap-vnet'

resource privateDnsZones_privatelink_file_core_windows_net_name_resource 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDnsZones_privatelink_file_core_windows_net_name
  location: 'global'
  properties: {}
}

resource privateDnsZones_privatelink_file_core_windows_net_name_secwfstorage 'Microsoft.Network/privateDnsZones/A@2020-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: 'secwfstorage'
  properties: {
    metadata: {
      creator: 'created by private endpoint rdu-private-endpoint-test-01 with resource guid d5d89588-f6f4-4607-bdd5-c9366beafebf'
    }
    ttl: 10
    aRecords: [
      {
        ipv4Address: '10.4.2.4'
      }
    ]
  }
}

resource Microsoft_Network_privateDnsZones_SOA_privateDnsZones_privatelink_file_core_windows_net_name 'Microsoft.Network/privateDnsZones/SOA@2020-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: '@'
  properties: {
    ttl: 3600
    soaRecord: {
      email: 'azureprivatedns-host.microsoft.com'
      expireTime: 2419200
      host: 'azureprivatedns.net'
      minimumTtl: 10
      refreshTime: 3600
      retryTime: 300
      serialNumber: 1
    }
  }
}

resource privateDnsZones_privatelink_file_core_windows_net_name_qm66pq6rgcp76 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZones_privatelink_file_core_windows_net_name_resource
  name: 'qm66pq6rgcp76'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: virtualNetworks_sec_wf_lap_vnet_externalid
    }
  }
}
