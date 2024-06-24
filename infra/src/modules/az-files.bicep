param sec_wf_storageAccnt_name string
param sec_wf_file_share_name string

resource storageAccounts_resource 'Microsoft.Storage/storageAccounts@2023-05-01' = {
  name: sec_wf_storageAccnt_name
  location: resourceGroup().location
  sku: {
    name: 'Standard_LRS'
    //tier: 'Standard'
  }
  kind: 'StorageV2'
  properties: {
    dnsEndpointType: 'Standard'
    defaultToOAuthAuthentication: false
    publicNetworkAccess: 'Enabled'
    allowCrossTenantReplication: false
    isLocalUserEnabled: true
    isSftpEnabled: false
    minimumTlsVersion: 'TLS1_2'
    allowBlobPublicAccess: false
    allowSharedKeyAccess: true
    largeFileSharesState: 'Enabled'
    isHnsEnabled: true
    networkAcls: {
      bypass: 'AzureServices'
      virtualNetworkRules: []
      ipRules: []
      defaultAction: 'Allow'
    }
    supportsHttpsTrafficOnly: true
    encryption: {
      requireInfrastructureEncryption: false
      services: {
        file: {
          keyType: 'Account'
          enabled: true
        }
        blob: {
          keyType: 'Account'
          enabled: true
        }
      }
      keySource: 'Microsoft.Storage'
    }
    accessTier: 'Cool'
  }
}

resource blobServices_default 'Microsoft.Storage/storageAccounts/blobServices@2023-05-01' = {
  parent: storageAccounts_resource
  name: 'default'
  // sku: {
  //   name: 'Standard_LRS'
  //   tier: 'Standard'
  // }
  properties: {
    cors: {
      corsRules: []
    }
    deleteRetentionPolicy: {
      allowPermanentDelete: false
      enabled: true
      days: 7
    }
    containerDeleteRetentionPolicy: {
      enabled: true
      days: 7
    }
  }
}

resource fileServices_default 'Microsoft.Storage/storageAccounts/fileServices@2023-05-01' = {
  parent: storageAccounts_resource
  name: 'default'
  // sku: {
  //   name: 'Standard_LRS'
  //   tier: 'Standard'
  // }
  properties: {
    protocolSettings: {
      smb: {}
    }
    cors: {
      corsRules: []
    }
    shareDeleteRetentionPolicy: {
      enabled: true
      days: 14
    }
  }
}

resource queueServices_name_default 'Microsoft.Storage/storageAccounts/queueServices@2023-05-01' = {
  parent: storageAccounts_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource tableServices_name_default 'Microsoft.Storage/storageAccounts/tableServices@2023-05-01' = {
  parent: storageAccounts_resource
  name: 'default'
  properties: {
    cors: {
      corsRules: []
    }
  }
}

resource file_share 'Microsoft.Storage/storageAccounts/fileServices/shares@2023-05-01' = {
  parent: fileServices_default
  name: sec_wf_file_share_name
  properties: {
    accessTier: 'Cool'
    shareQuota: 102400
    enabledProtocols: 'SMB'
  }
}
