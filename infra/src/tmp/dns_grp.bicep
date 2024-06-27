param privateEndpoints_sec_wf_priv_endpoint_name string = 'sec-wf-priv-endpoint'
param storageAccounts_secwfstorage_externalid string = '/subscriptions/de47847e-1e04-4c18-99de-a11f659d3119/resourceGroups/sec-wf-files-rg/providers/Microsoft.Storage/storageAccounts/secwfstorage'
param virtualNetworks_sec_wf_lap_vnet_externalid string = '/subscriptions/de47847e-1e04-4c18-99de-a11f659d3119/resourceGroups/sec-wf-workflow-rg/providers/Microsoft.Network/virtualNetworks/sec-wf-lap-vnet'
param privateDnsZones_privatelink_file_core_windows_net_externalid string = '/subscriptions/de47847e-1e04-4c18-99de-a11f659d3119/resourceGroups/sec-wf-workflow-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net'

resource privateEndpoints_sec_wf_priv_endpoint_name_resource 'Microsoft.Network/privateEndpoints@2023-11-01' = {
  name: privateEndpoints_sec_wf_priv_endpoint_name
  location: 'polandcentral'
  properties: {
    privateLinkServiceConnections: [
      {
        name: privateEndpoints_sec_wf_priv_endpoint_name
        id: '${privateEndpoints_sec_wf_priv_endpoint_name_resource.id}/privateLinkServiceConnections/${privateEndpoints_sec_wf_priv_endpoint_name}'
        properties: {
          privateLinkServiceId: storageAccounts_secwfstorage_externalid
          groupIds: [
            'file'
          ]
          privateLinkServiceConnectionState: {
            status: 'Approved'
            description: 'Auto-Approved'
            actionsRequired: 'None'
          }
        }
      }
    ]
    manualPrivateLinkServiceConnections: []
    customNetworkInterfaceName: '${privateEndpoints_sec_wf_priv_endpoint_name}-nic'
    subnet: {
      id: '${virtualNetworks_sec_wf_lap_vnet_externalid}/subnets/sec-wf-lap-snet-1'
    }
    ipConfigurations: []
    customDnsConfigs: []
  }
}

resource privateEndpoints_sec_wf_priv_endpoint_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  name: '${privateEndpoints_sec_wf_priv_endpoint_name}/default'
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'foo_privatelink_file_core_windows_net'
        properties: {
          privateDnsZoneId: privateDnsZones_privatelink_file_core_windows_net_externalid
        }
      }
    ]
  }
  dependsOn: [
    privateEndpoints_sec_wf_priv_endpoint_name_resource
  ]
}
