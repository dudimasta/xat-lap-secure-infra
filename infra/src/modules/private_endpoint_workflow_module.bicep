param subnet_resource_id string
param privateEndpointName string
param privateEndpointNicName string
param targetSubResource array
param privateLinkResource_id string


resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' =  {
  location: resourceGroup().location
  name: privateEndpointName
  properties: {
    subnet: {
      id: subnet_resource_id
    }
    customNetworkInterfaceName: privateEndpointNicName
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: privateLinkResource_id
          groupIds: targetSubResource
        }
      }
    ]
  }
  tags: {}
  dependsOn: []
}
