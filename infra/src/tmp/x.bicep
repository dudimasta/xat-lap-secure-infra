param virtualMachines_test_access_vm_name string = 'test-access-vm'
param disks_test_access_vm_OsDisk_1_8124a9cc57b94caeb4b68b0be6e68e7f_externalid string = '/subscriptions/872d7f5d-34ce-4fd2-aad8-4259b54f3aa6/resourceGroups/rdu-oracle-vm2_group/providers/Microsoft.Compute/disks/test-access-vm_OsDisk_1_8124a9cc57b94caeb4b68b0be6e68e7f'
param networkInterfaces_test_access_vm908_externalid string = '/subscriptions/872d7f5d-34ce-4fd2-aad8-4259b54f3aa6/resourceGroups/rdu-oracle-vm2_group/providers/Microsoft.Network/networkInterfaces/test-access-vm908'

resource virtualMachines_test_access_vm_name_resource 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: virtualMachines_test_access_vm_name
  location: 'northeurope'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B1s'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'canonical'
        offer: '0001-com-ubuntu-minimal-jammy'
        sku: 'minimal-22_04-lts-gen2'
        version: 'latest'
      }
      osDisk: {
        osType: 'Linux'
        name: '${virtualMachines_test_access_vm_name}_OsDisk_1_8124a9cc57b94caeb4b68b0be6e68e7f'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: disks_test_access_vm_OsDisk_1_8124a9cc57b94caeb4b68b0be6e68e7f_externalid
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_test_access_vm_name
      adminUsername: 'vmadmin'
      linuxConfiguration: {
        disablePasswordAuthentication: false
        provisionVMAgent: true
        patchSettings: {
          patchMode: 'ImageDefault'
          assessmentMode: 'ImageDefault'
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
    }
    securityProfile: {
      uefiSettings: {
        secureBootEnabled: true
        vTpmEnabled: true
      }
      securityType: 'TrustedLaunch'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_test_access_vm908_externalid
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}
