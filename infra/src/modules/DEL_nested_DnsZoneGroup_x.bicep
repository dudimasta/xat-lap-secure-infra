param privateEndpointName string
param location string
param privateDnsZoneId string

resource privateEnpodint_symbol 'Microsoft.Network/privateEndpoints@2023-11-01' existing = {
  // name: privateEndpointName
  name: 'faker'
}
// 
// resource privateEndpointName_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
//   //name: '${privateEndpointName}/default'
//   name: 'default'
//   parent: privateEnpodint_symbol
//   #disable-next-line BCP187
//   location: location
//   properties: {
//     privateDnsZoneConfigs: [
//       {
//         name: 'privatelink-file-core-windows-net'
//         properties: { privateDnsZoneId: privateDnsZoneId }
//       }
//     ]
//   }
// }

// resource symbolicname 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
//   name: 'default'
//   parent: privateEnpodint_symbol
//   properties: {
//     privateDnsZoneConfigs: [
//       {
//         name: 'goo-privatelink-file-core-windows-net'
//         properties: {
//           privateDnsZoneId: privateDnsZoneId
//         }
//       }
//     ]
//   }
//   dependsOn:[
//     privateEnpodint_symbol
//   ]
// }

// resource privateEndpoints_sec_wf_priv_endpoint_name_resource 'Microsoft.Network/privateEndpoints@2023-11-01' existing = {
//   name: privateEndpointName
// }

// resource privateEndpoints_sec_wf_priv_endpoint_name_default 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
//   name: '${privateEndpointName}/default'
//   properties: {
//     privateDnsZoneConfigs: [
//       {
//         name: 'foo_privatelink_file_core_windows_net'
//         properties: {
//           // privateDnsZoneId: privateDnsZones_privatelink_file_core_windows_net_externalid
//           privateDnsZoneId: privateDnsZoneId
//         }
//       }
//     ]
//   }
//   dependsOn: [
//     privateEndpoints_sec_wf_priv_endpoint_name_resource
//   ]
// }

// // Create PrivateEndpointDnsZoneGroup service 
// resource privateEndpointDsnZoneGroupResource 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2020-07-01' = {
//   name: '${privateEndpointName}/default'
//   properties: {
//     privateDnsZoneConfigs: [
//       {
//         name: 'foo_privatelink_file_core_windows_net'
//         properties: {
//           privateDnsZoneId: privateDnsZoneId
//         }
//       }
//     ]
//   }
//   dependsOn: [
//     //<Your private Endpoint resource or module>
//     privateEndpoints_sec_wf_priv_endpoint_name_resource
//   ]
// }

// template z ms
// resource symbolicname 'Microsoft.Network/privateEndpoints/privateDnsZoneGroups@2023-11-01' = {
//   name: 'string'
//   parent: resourceSymbolicName
//   properties: {
//     privateDnsZoneConfigs: [
//       {
//         name: 'string'
//         properties: {
//           privateDnsZoneId: 'string'
//         }
//       }
//     ]
