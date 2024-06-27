
param privateEndpointName string

resource privatelink_file_core_windows_net 'Microsoft.Network/privateDnsZones@2018-09-01' existing = {
  #disable-next-line no-hardcoded-env-urls
  name: 'privatelink.file.core.windows.net'
}

resource privateDnsZone_symbol 'Microsoft.Network/privateDnsZones@2020-06-01' existing = {
  name: privatelink_file_core_windows_net.id
}

resource privateEnpodint_symbol 'Microsoft.Network/privateEndpoints@2023-11-01' existing = {
  
  name: privateEndpointName
}
param privateDnsZoneId string = '${resourceGroup().id}/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net'
resource symbolicname 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  name: 'default'
  parent: privateEnpodint_symbol
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'goo-privatelink-file-core-windows-net'
        properties: {
          //privateDnsZoneId: '/subscriptions/de47847e-1e04-4c18-99de-a11f659d3119/resourceGroups/sec-wf-workflow-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net'
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
  dependsOn:[
    privatelink_file_core_windows_net, privateDnsZone_symbol
  ]
}

