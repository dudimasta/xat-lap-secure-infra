param virtualNetworkId string

module VirtualNetworklink_b8b6a5dc_c823_4e61_bda5_efe945b9a09c './nested_VirtualNetworklink_b8b6a5dc_c823_4e61_bda5_efe945b9a09c.bicep' = {
  name: 'VirtualNetworklink-b8b6a5dc-c823-4e61-bda5-efe945b9a09c'
  scope: resourceGroup('de47847e-1e04-4c18-99de-a11f659d3119', 'sec-wf-workflow-rg')
  params: {
    virtualNetworkId: virtualNetworkId
  }
}
