#! /bin/sh
export $(grep -v '^#' .env | xargs -d '\n')

# change default action to deny, so only explicit ACL will be in use:
az storage account update --resource-group $FILES_RG_NAME --name $SEC_WF_STORAGEACCNT_NAME --default-action Deny