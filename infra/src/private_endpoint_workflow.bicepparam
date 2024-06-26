using 'private_endpoint_workflow.bicep'

// param location=readEnvironmentVariable('WORKFLOW_RG_LOCATION')
// param privateEndpointName=readEnvironmentVariable('WORKFLOW_PRIVATE_ENDPOINT_NAME')
// param subnet_name =  /*TODO*/

param files_rg_name=readEnvironmentVariable('FILES_RG_NAME')
param workflow_rg_name=readEnvironmentVariable('WORKFLOW_RG_NAME')

param workflow_vnet_name=readEnvironmentVariable('WORKFLOW_VNET_NAME')
param workflow_subnet_name=readEnvironmentVariable('WORKFLOW_SUBNET_1_NAME')

param privateEndpointName=readEnvironmentVariable('WORKFLOW_PRIVATE_ENDPOINT_NAME')
param privateEndpointNicName=readEnvironmentVariable('WORKFLOW_PRIVATE_ENDPOINT_NIC_NAME')
param sec_wf_storageaccnt_name=readEnvironmentVariable('SEC_WF_STORAGEACCNT_NAME')

