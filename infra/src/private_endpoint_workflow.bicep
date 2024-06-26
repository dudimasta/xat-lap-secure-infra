targetScope='subscription'

// param requestMessage string
// param virtualNetworkId string
// param virtualNetworkResourceGroup string
// param subnetDeploymentName string
// param privateDnsDeploymentName string

param privateEndpointName string

// origin of private link, e.g. '/subscriptions/de47847e-1e04-4c18-99de-a11f659d3119/resourceGroups/sec-wf-files-rg/providers/Microsoft.Storage/storageAccounts/secwfstorage'

// to what kind of resource you want to grant access using the private endpoint, e.g. [ "file" ]
param targetSubResource array = [
  'file'
]

// pobieramy info o resource grupach:
param files_rg_name string
resource resourceGroup_files 'Microsoft.Resources/resourceGroups@2024-03-01' existing = {
  name: files_rg_name
}

param workflow_rg_name string
resource resourceGroup_workflow 'Microsoft.Resources/resourceGroups@2024-03-01' existing = {
  name: workflow_rg_name
}

param workflow_vnet_name string
resource vnet_name 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  scope: resourceGroup_workflow
  name: workflow_vnet_name
}


param workflow_subnet_name string
// subnet id, e.g. /subscriptions/de47847e-1e04-4c18-99de-a11f659d3119/resourceGroups/sec-wf-workflow-rg/providers/Microsoft.Network/virtualNetworks/sec-wf-lap-vnet/subnets/sec-wf-lap-snet-1
// param subnet string = 'foo'
resource subnet_resource 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  
  parent: vnet_name
  name: workflow_subnet_name
}

param sec_wf_storageaccnt_name string
resource storage_account_resource 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: sec_wf_storageaccnt_name
  scope: resourceGroup_files
}

module endpoint_creating_module './modules/private_endpoint_workflow_module.bicep' = {
  scope: resourceGroup_workflow
  name: privateEndpointName
  params: {
    privateEndpointName: privateEndpointName
    subnet_resource_id: subnet_resource.id
    targetSubResource: targetSubResource
    privateLinkResource_id: storage_account_resource.id
  }
}

// module privateDnsDeployment './nested_privateDnsDeployment.bicep' = {
//   name: privateDnsDeploymentName
//   params: {}
//   dependsOn: [
//     privateEndpoint
//   ]
// }
// 
// module VirtualNetworkLink_20240626171526 './nested_VirtualNetworkLink_20240626171526.bicep' = {
//   name: 'VirtualNetworkLink-20240626171526'
//   params: {
//     virtualNetworkId: virtualNetworkId
//   }
//   dependsOn: [
//     privateDnsDeployment
//   ]
// }

// module DnsZoneGroup_20240626171526 './nested_DnsZoneGroup_20240626171526.bicep' = {
//   name: 'DnsZoneGroup-20240626171526'
//   scope: resourceGroup('sec-wf-workflow-rg')
//   params: {
//     privateEndpointName: privateEndpointName
//     location: location
//   }
//   dependsOn: [
//     privateEndpoint
//     privateDnsDeployment
//   ]
// }
