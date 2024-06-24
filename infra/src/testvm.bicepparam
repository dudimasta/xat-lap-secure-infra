using 'testvm.bicep'

param linux_vm_ip_address_name=readEnvironmentVariable('LINUX_VM_IP_ADDRESS_NAME')
param linux_vm_nic_name=readEnvironmentVariable('LINUX_VM_NIC_NAME')
param linux_vm_nic_subnet=readEnvironmentVariable('ACCESS_SUBNET_2_NAME')
param linux_vm_nsg_name=readEnvironmentVariable('LINUX_VM_NSG_NAME')
param secure_access_vnet_name=readEnvironmentVariable('ACCESS_VNET_NAME')
param linux_vm_name=readEnvironmentVariable('LINUX_VM_NAME')
// param disk_name=concat(readEnvironmentVariable('LINUX_VM_NAME'), replace('ec2c00a5-3f21-4f4c-bfad-69ee436daec2', '-', ''))
param linux_vm_admin=readEnvironmentVariable('LINUX_VM_ADMIN')
param linux_vm_admin_pwd=readEnvironmentVariable('LINUX_VM_ADMIN_PWD')
