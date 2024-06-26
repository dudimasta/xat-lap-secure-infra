param parent_vnet_name string
param snet_address_prefixes string
param snet_name string

targetScope='resourceGroup'

resource parentVnet 'Microsoft.Network/virtualNetworks@2020-11-01' existing = {
  name: parent_vnet_name
}

resource secure_vnet_name_AzureFirewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' = {
  parent: parentVnet
  name: snet_name
  properties: {
    addressPrefixes: [
      snet_address_prefixes
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
  }
}


