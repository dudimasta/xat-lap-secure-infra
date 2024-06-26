using 'private_endpoint_workflow.bicep'

param location=readEnvironmentVariable('WORKFLOW_RG_LOCATION')
param privateEndpointName=readEnvironmentVariable('WORKFLOW_PRIVATE_ENDPOINT_NAME')
param subnet_name =  /*TODO*/
