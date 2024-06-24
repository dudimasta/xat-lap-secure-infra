using 'main.bicep'

param files_rg_name=readEnvironmentVariable('FILES_RG_NAME')
param files_rg_location=readEnvironmentVariable('FILES_RG_LOCATION')


param databus_rg_name=readEnvironmentVariable('DATABUS_RG_NAME')
param databus_rg_location=readEnvironmentVariable('DATABUS_RG_LOCATION')

param workflow_rg_name=readEnvironmentVariable('WORKFLOW_RG_NAME')
param workflow_rg_location=readEnvironmentVariable('WORKFLOW_RG_LOCATION')

param access_rg_name=readEnvironmentVariable('ACCESS_RG_NAME')
param access_rg_location=readEnvironmentVariable('ACCESS_RG_LOCATION')

param secure_vnet_name=readEnvironmentVariable('ACCESS_VNET_NAME')
param secure_vnet_address_prefixes=readEnvironmentVariable('ACCESS_VNET_ADDRESS_PREFIXES')

param snet_2_name=readEnvironmentVariable('ACCESS_SUBNET_2_NAME')
param snet_2_prefix=readEnvironmentVariable('ACCESS_SUBNET_2_ADDRESS')

param snet_3_name=readEnvironmentVariable('ACCESS_SUBNET_3_NAME')
param snet_3_prefix=readEnvironmentVariable('ACCESS_SUBNET_3_ADDRESS')

param snet_default_name=readEnvironmentVariable('ACCESS_SUBNET_DEFAULT_NAME')
param snet_default_prefix=readEnvironmentVariable('ACCESS_SUBNET_DEFAULT_ADDRESS')

param snet_firewall_name=readEnvironmentVariable('ACCESS_SUBNET_FIREWALL_NAME')
param snet_firewall_prefix=readEnvironmentVariable('ACCESS_SUBNET_FIREWALL_ADDRESS')

param linux_vm_ip_address_name=readEnvironmentVariable('LINUX_VM_IP_ADDRESS_NAME')
param linux_vm_nsg_name=readEnvironmentVariable('LINUX_VM_NSG_NAME')

param sec_wf_file_share_name=readEnvironmentVariable('SEC_WF_FILE_SHARE_NAME')
param sec_wf_storageAccnt_name=readEnvironmentVariable('SEC_WF_STORAGEACCNT_NAME')
