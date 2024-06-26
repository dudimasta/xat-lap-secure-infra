param location string
param privateEndpointName string
param privateLinkResource string
param targetSubResource array
param requestMessage string
param subnet string
param virtualNetworkId string
param virtualNetworkResourceGroup string
param subnetDeploymentName string
param privateDnsDeploymentName string

resource privateEndpoint 'Microsoft.Network/privateEndpoints@2021-05-01' = {
  location: location
  name: privateEndpointName
  properties: {
    subnet: {
      id: subnet
    }
    customNetworkInterfaceName: 'rdu-private-endpoint-test-0-nic'
    privateLinkServiceConnections: [
      {
        name: privateEndpointName
        properties: {
          privateLinkServiceId: privateLinkResource
          groupIds: targetSubResource
        }
      }
    ]
  }
  tags: {}
  dependsOn: []
}

module privateDnsDeployment './nested_privateDnsDeployment.bicep' = {
  name: privateDnsDeploymentName
  params: {}
  dependsOn: [
    privateEndpoint
  ]
}

module VirtualNetworkLink_20240626171526 './nested_VirtualNetworkLink_20240626171526.bicep' = {
  name: 'VirtualNetworkLink-20240626171526'
  params: {
    virtualNetworkId: virtualNetworkId
  }
  dependsOn: [
    privateDnsDeployment
  ]
}

module DnsZoneGroup_20240626171526 './nested_DnsZoneGroup_20240626171526.bicep' = {
  name: 'DnsZoneGroup-20240626171526'
  scope: resourceGroup('sec-wf-workflow-rg')
  params: {
    privateEndpointName: privateEndpointName
    location: location
  }
  dependsOn: [
    privateEndpoint
    privateDnsDeployment
  ]
}
