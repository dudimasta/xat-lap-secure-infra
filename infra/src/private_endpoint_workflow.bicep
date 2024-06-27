targetScope = 'subscription'

// param requestMessage string
// param virtualNetworkId string
// param virtualNetworkResourceGroup string
// param subnetDeploymentName string
// param privateDnsDeploymentName string

param privateEndpointName string
param privateEndpointNicName string

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
resource workflow_vnet_resource 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  scope: resourceGroup_workflow
  name: workflow_vnet_name
}

param workflow_subnet_name string
// subnet id, e.g. /subscriptions/de47847e-1e04-4c18-99de-a11f659d3119/resourceGroups/sec-wf-workflow-rg/providers/Microsoft.Network/virtualNetworks/sec-wf-lap-vnet/subnets/sec-wf-lap-snet-1
// param subnet string = 'foo'
resource subnet_resource 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  parent: workflow_vnet_resource
  name: workflow_subnet_name
}

param sec_wf_storageaccnt_name string
resource storage_account_resource 'Microsoft.Storage/storageAccounts@2023-05-01' existing = {
  name: sec_wf_storageaccnt_name
  scope: resourceGroup_files
}

// creating private endpoint
module private_endpoint_creating_module './modules/private_endpoint_workflow_module.bicep' = {
  scope: resourceGroup_workflow
  name: privateEndpointName
  params: {
    privateEndpointName: privateEndpointName
    privateEndpointNicName: privateEndpointNicName
    subnet_resource_id: subnet_resource.id
    targetSubResource: targetSubResource
    privateLinkResource_id: storage_account_resource.id
  }
}

// creating private DNS zone
var privateDnsZoneName = 'PrivateDnsZone-5a62e075-04f7-4a96-8d5f-4c9bb8fbd377'
module PrivateDnsZone_deployment './modules/nested_PrivateDnsZone_deployment.bicep' = {
  //name: 'PrivateDnsZone-5a62e075-04f7-4a96-8d5f-4c9bb8fbd377'
  name: privateDnsZoneName
  scope: resourceGroup_workflow
  params: {}
  dependsOn: [
    private_endpoint_creating_module
  ]
}

// create virtual network link
module VirtualNetworklink_resource './modules/nested_VirtualNetworklink.bicep' = {
  name: 'VirtualNetworklink-5a62e075-04f7-4a96-8d5f-4c9bb8fbd377'
  scope: resourceGroup_workflow
  params: {
    virtualNetworkId: workflow_vnet_resource.id
    #disable-next-line no-hardcoded-env-urls
    privatelink_name: 'privatelink.file.core.windows.net/${uniqueString(workflow_vnet_resource.id)}'
  }
  dependsOn: [
    PrivateDnsZone_deployment
  ]
}


