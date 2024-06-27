#! /bin/sh
#
export $(grep -v '^#' .env | xargs -d '\n')
#
mkdir -p output
rm ./output/*.json
#
# tworzymy bazowe zasoby w resource grupach (Azure Files, workflow i data bus)
bicep build-params ./src/main.bicepparam --outfile ./output/main.json
az deployment sub create --location $FILES_RG_LOCATION --template-file ./src/main.bicep --parameters ./output/main.json
#
# deploy maszyny z linuxem do testowania komunikacji
bicep build-params ./src/testvm.bicepparam --outfile ./output/testvm.json
az deployment group create -g $ACCESS_RG_NAME --template-file ./src/testvm.bicep --parameters ./output/testvm.json
# tworzymy private endpoint do bezpiecznej komunikacji od workflowów (LogicApps) do Az File
bicep build-params ./src/private_endpoint_workflow.bicepparam --outfile ./output/private_endpoint_workflow.json
az deployment sub create --location $FILES_RG_LOCATION --template-file ./src/private_endpoint_workflow.bicep --parameters ./output/private_endpoint_workflow.json

bicep build-params ./src/private_endpoint_dns.bicepparam --outfile ./output/private_endpoint_dns.json
az deployment group create -g $WORKFLOW_RG_NAME --template-file ./src/private_endpoint_dns.bicep --parameters ./output/private_endpoint_dns.json