// object definig vnet properties:
param secure_vnet_name string
param secure_vnet_address_prefixes string

param snet_firewall_name string
param snet_firewall_prefix string
param snet_default_name string
param snet_default_prefix string
param snet_2_name string
param snet_2_prefix string
param snet_3_name string
param snet_3_prefix string

param secure_access_vnet object = {
  name: secure_vnet_name
  addressPrefixes: [
    secure_vnet_address_prefixes
  ]
  subnets: [
    {
      name: snet_firewall_name
      addressPrefix: snet_firewall_prefix
    }
    {
      name: snet_default_name
      addressPrefix: snet_default_prefix
    }
    {
      name: snet_2_name
      addressPrefix: snet_2_prefix
    }
    {
      name: snet_3_name
      addressPrefix: snet_3_prefix
    }
  ]
}

targetScope='subscription'

// dedykowana RG dla Az Files
param files_rg_name string
param files_rg_location string
resource resourceGroup_files 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: files_rg_name
  location: files_rg_location
}

// dedykowana RG dla LogicApps
param workflow_rg_name string
param workflow_rg_location string
resource resourceGroup_workflow 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: workflow_rg_name
  location: workflow_rg_location
}

// dedykowana RG dla szyny danych
param databus_rg_name string
param databus_rg_location string
resource resourceGroup_databus 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: databus_rg_name
  location: databus_rg_location
}

// dedykowana RG dla zabezpieczeń dostępu (sieci prywatne)
param access_rg_name string
param access_rg_location string
resource resourceGroup_access 'Microsoft.Resources/resourceGroups@2024-03-01' = {
  name: access_rg_name
  location: access_rg_location 
}

module secure_vnet_module './modules/v-net.bicep' = {
  scope: resourceGroup_access
  name: secure_access_vnet.name
  params: {
    name: secure_access_vnet.name
    location: resourceGroup_access.location
    addressPrefixes: secure_access_vnet.addressPrefixes
  }
}

// create subnets inside the vnet
@batchSize(1)
module secure_subnet_module './modules/subnet.bicep' = [for subnet in secure_access_vnet.subnets: {
  scope: resourceGroup_access
  name: subnet.name
  params: {
    parent_vnet_name: secure_vnet_module.name
    snet_address_prefixes: subnet.addressPrefix
    snet_name: subnet.name
  }
}]

param sec_wf_storageAccnt_name string
param sec_wf_file_share_name string
// // create az storage account and file storage:
module az_files 'modules/az-files.bicep' = {
  name: sec_wf_storageAccnt_name
  scope: resourceGroup_files
  params: {
    sec_wf_storageAccnt_name: sec_wf_storageAccnt_name
    sec_wf_file_share_name: sec_wf_file_share_name
  }
}

param linux_vm_ip_address_name string
// creating elements of linux vm used for connection testing
module linux_vm_ip_address 'modules/linux-vm-ip-address.bicep' = {
  name: linux_vm_ip_address_name
  scope: resourceGroup_access
  params: {
    linux_vm_ip_address_name: linux_vm_ip_address_name
  }
}

param linux_vm_nsg_name string
module linux_vm_nsg 'modules/linux-vm-nsg.bicep' = {
  name: linux_vm_nsg_name
  scope: resourceGroup_access
  params: {
    linux_vm_nsg_name: linux_vm_nsg_name
  }
}


// ***************************
// // look for the nsg:
// resource linux_vm_nsg_resource 'Microsoft.Network/networkSecurityGroups@2023-11-01' existing = {
//   name: linux_vm_nsg_name
//   scope: resourceGroup_access
// }
// 
// resource linux_vm_nic_resource 'Microsoft.Network/networkInterfaces@2023-11-01' existing = {
//   name: linux_vm_nic_name
//   scope: resourceGroup_access
// }
// 
// // Update the nic - add nsg to nic
// module attachNsg './modules/update-nic.bicep' = {
//   name: 'update-nic-${secure_access_vnet.name}-${linux_vm_nic_subnet}'
//   scope: resourceGroup_access
//   params: {
//     nic_name: linux_vm_nic_name
//     // Update the nsg
//     properties: union(linux_vm_nic_resource.properties, {
//       networkSecurityGroup: {
//         id: linux_vm_nsg_resource.id
//       }
//     })
//   }
// }

