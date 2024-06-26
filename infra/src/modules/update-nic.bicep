param nic_name string
param properties object

// // Get existing vnet
// resource vnet 'Microsoft.Network/virtualNetworks@2022-01-01' existing = {
//   name: vnetName
// }
// 
// resource subnet 'Microsoft.Network/virtualNetworks/subnets@2022-01-01' = {
//   name: subnetName
//   parent: vnet
//   properties: properties
// }

resource nic_name_resource 'Microsoft.Network/networkInterfaces@2023-11-01' = {
  name: nic_name
  properties: properties
}
