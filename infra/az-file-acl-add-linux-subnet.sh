#! /bin/sh
export $(grep -v '^#' .env | xargs -d '\n')

# enable service endpoints
az network vnet subnet update --resource-group $ACCESS_RG_NAME --vnet-name $ACCESS_VNET_NAME --name $ACCESS_SUBNET_2_NAME --service-endpoints "Microsoft.Storage.Global"


# add rule to storage account
subnetid=$(az network vnet subnet show --resource-group $ACCESS_RG_NAME --vnet-name $ACCESS_VNET_NAME --name $ACCESS_SUBNET_2_NAME --query id --output tsv)
az storage account network-rule add --resource-group $FILES_RG_NAME --account-name $SEC_WF_STORAGEACCNT_NAME --subnet $subnetid

# use below to remove rule from ACL: 
#az storage account network-rule remove --resource-group $FILES_RG_NAME --account-name SEC_WF_STORAGEACCNT_NAME --subnet $subnetid