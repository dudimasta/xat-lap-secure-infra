#! /bin/sh

export $(grep -v '^#' .env | xargs -d '\n')

rm ./output/*.json

# tworzymy resource grupy, w której będą zdeployowane zasoby dla Azure Files, workflow i data bus
bicep build-params ./src/main.bicepparam --outfile ./output/main.json
az deployment sub create --location $FILES_RG_LOCATION --template-file ./src/main.bicep --parameters ./output/main.json

bicep build-params ./src/testvm.bicepparam --outfile ./output/testvm.json
az deployment group create -g $ACCESS_RG_NAME --template-file ./src/testvm.bicep --parameters ./output/testvm.json