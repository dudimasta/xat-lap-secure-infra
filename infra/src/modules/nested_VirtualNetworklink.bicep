param virtualNetworkId string
param privatelink_name string

resource privatelink_file_core_windows_net_virtualNetworkId 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2018-09-01' = {
#disable-next-line no-hardcoded-env-urls
  //name: 'privatelink.file.core.windows.net/${uniqueString(virtualNetworkId)}'
  name: privatelink_name
  location: 'global'
  properties: {
    virtualNetwork: {
      id: virtualNetworkId
    }
    registrationEnabled: false
  }
}
