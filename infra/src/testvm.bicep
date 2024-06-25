param linux_vm_nic_subnet string
param linux_vm_nsg_name string
param secure_access_vnet_name string
param linux_vm_ip_address_name string

resource linux_vm_nsg_resource 'Microsoft.Network/networkSecurityGroups@2023-11-01' existing = {
  name: linux_vm_nsg_name
  scope: resourceGroup()
}

resource linux_vm_vnet 'Microsoft.Network/virtualNetworks@2023-11-01' existing = {
  name: secure_access_vnet_name
  scope: resourceGroup()
}

resource linux_vm_nic_subnet_resource 'Microsoft.Network/virtualNetworks/subnets@2023-11-01' existing = {
  name: linux_vm_nic_subnet
  parent: linux_vm_vnet
}

resource linux_vm_ip_address_resource 'Microsoft.Network/publicIPAddresses@2023-11-01' existing = {
  name: linux_vm_ip_address_name
  scope: resourceGroup()
}

param linux_vm_nic_name string
module linux_vm_nic 'modules/linux-vm-nic.bicep' = {
  scope: resourceGroup()
  name: linux_vm_nic_name
  params: {
    nic_name: linux_vm_nic_name
    vnet_name: secure_access_vnet_name
    subnet_name: linux_vm_nic_subnet
    publicIpAddress_name: linux_vm_ip_address_name
    nsg_name: linux_vm_nsg_name
  }
  dependsOn: [
    linux_vm_nsg_resource
    linux_vm_vnet
    linux_vm_nic_subnet_resource
    linux_vm_ip_address_resource
  ]
}

resource linux_nic 'Microsoft.Network/networkInterfaces@2023-11-01' existing = {
  name: linux_vm_nic_name
}

param linux_vm_name string
param linux_vm_admin string
@secure()
param linux_vm_admin_pwd string
module sym_vm 'modules/linux-vm.bicep' = {
  name: linux_vm_name
  params: {
    linux_vm_name: linux_vm_name
    nic_id: linux_nic.id
    vm_admin_pwd: linux_vm_admin_pwd
    vm_admin_user: linux_vm_admin
  }
  dependsOn: [
    linux_nic
  ]
}
