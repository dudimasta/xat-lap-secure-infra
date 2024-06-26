// object definig vnet properties:
param secure_vnet_name_linux string
param secure_vnet_address_prefixes_linux string

param snet_firewall_name_linux string
param snet_firewall_prefix_linux string
param snet_default_name_linux string
param snet_default_prefix_linux string
param snet_2_name_linux string
param snet_2_prefix_linux string
param snet_3_name_linux string
param snet_3_prefix_linux string

param secure_access_vnet_linux object = {
  name: secure_vnet_name_linux
  addressPrefixes: [
    secure_vnet_address_prefixes_linux
  ]
  subnets: [
    {
      name: snet_firewall_name_linux
      addressPrefix: snet_firewall_prefix_linux
    }
    {
      name: snet_default_name_linux
      addressPrefix: snet_default_prefix_linux
    }
    {
      name: snet_2_name_linux
      addressPrefix: snet_2_prefix_linux
    }
    {
      name: snet_3_name_linux
      addressPrefix: snet_3_prefix_linux
    }
  ]
}


param secure_vnet_name_lap string
param secure_vnet_address_prefixes_lap string
param snet_1_name_lap string
param snet_1_prefix_lap string
param snet_2_name_lap string
param snet_2_prefix_lap string

param secure_access_vnet_lap object = {
  name: secure_vnet_name_lap
  addressPrefixes: [
    secure_vnet_address_prefixes_lap
  ]
  subnets: [
    {
      name: snet_1_name_lap
      addressPrefix: snet_1_prefix_lap
    }
    {
      name: snet_2_name_lap
      addressPrefix: snet_2_prefix_lap
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

// Vnet w grupie z linuxem (access)
module secure_vnet_module_linux './modules/v-net.bicep' = {
  scope: resourceGroup_access
  name: secure_access_vnet_linux.name
  params: {
    name: secure_access_vnet_linux.name
    location: resourceGroup_access.location
    addressPrefixes: secure_access_vnet_linux.addressPrefixes
  }
}

// podzial vnetu na subnety w grupie z linuxem
@batchSize(1)
module secure_subnet_module_linux './modules/subnet.bicep' = [for subnet in secure_access_vnet_linux.subnets: {
  scope: resourceGroup_access
  name: subnet.name
  params: {
    parent_vnet_name: secure_vnet_module_linux.name
    snet_address_prefixes: subnet.addressPrefix
    snet_name: subnet.name
  }
}]

// Vnet w grupie z logic app (workflow)
module secure_vnet_module_lap './modules/v-net.bicep' = {
  scope: resourceGroup_workflow
  name: secure_access_vnet_lap.name
  params: {
    name: secure_access_vnet_lap.name
    location: resourceGroup_workflow.location
    addressPrefixes: secure_access_vnet_lap.addressPrefixes
  }
}

// podzial vnetu na subnety w grupie z logic app
@batchSize(1)
module secure_subnet_module_lap './modules/subnet.bicep' = [for subnet in secure_access_vnet_lap.subnets: {
  scope: resourceGroup_workflow
  name: subnet.name
  params: {
    parent_vnet_name: secure_vnet_module_lap.name
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

