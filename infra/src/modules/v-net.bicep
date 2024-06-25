param name string
param location string
param addressPrefixes array

resource secure_vnet_name_resource 'Microsoft.Network/virtualNetworks@2023-11-01' = {
  name: name
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: addressPrefixes
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}
