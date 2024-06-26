param privateEndpointName string
param location string
param privateDnsZoneId string

resource privateEndpointName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
  name: '${privateEndpointName}/default'
#disable-next-line BCP187
  location: location
  properties: {
    privateDnsZoneConfigs: [
      {
        name: 'privatelink-file-core-windows-net'
        properties: {
          privateDnsZoneId: privateDnsZoneId
        }
      }
    ]
  }
}
