param privateEndpointName string
param location string

resource privateEndpointName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2021-05-01' = {
  name: '${privateEndpointName}/default'
  location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-file-core-windows-net'
        properties: {
          privateDnsZoneId: '/subscriptions/de47847e-1e04-4c18-99de-a11f659d3119/resourceGroups/sec-wf-workflow-rg/providers/Microsoft.Network/privateDnsZones/privatelink.file.core.windows.net'
        }
      }
    ]
  }
}
