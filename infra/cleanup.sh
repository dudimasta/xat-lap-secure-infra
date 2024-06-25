#! /bin/sh

export $(grep -v '^#' .env | xargs -d '\n')

az group delete --name $FILES_RG_NAME --yes 
az group delete --name $WORKFLOW_RG_NAME --yes 
az group delete --name $DATABUS_RG_NAME --yes
az group delete --name $ACCESS_RG_NAME --yes 