#! /bin/sh
export $(grep -v '^#' .env | xargs -d '\n')

#az network public-ip show --name $LINUX_VM_IP_ADDRESS_NAME --resource-group $ACCESS_RG_NAME
az network public-ip show --name $LINUX_VM_IP_ADDRESS_NAME --resource-group $ACCESS_RG_NAME --output table

linux_vm_ip_address=$(az network public-ip show --name $LINUX_VM_IP_ADDRESS_NAME --resource-group $ACCESS_RG_NAME --query 'ipAddress')

echo 'to connect to your linux vm please type in your shell:'
echo ''
echo 'ssh '$LINUX_VM_ADMIN'@'$linux_vm_ip_address