param vm_admin_user string
@secure() 
param vm_admin_pwd string
param linux_vm_name string
// param managed_disk_id string = '/subscriptions/872d7f5d-34ce-4fd2-aad8-4259b54f3aa6/resourceGroups/rdu-oracle-vm2_group/providers/Microsoft.Compute/disks/test-access-vm_OsDisk_1_8124a9cc57b94caeb4b68b0be6e68e7f'
// param managed_disk_id string 
// param nic_id string = '/subscriptions/872d7f5d-34ce-4fd2-aad8-4259b54f3aa6/resourceGroups/rdu-oracle-vm2_group/providers/Microsoft.Network/networkInterfaces/test-access-vm908'
param nic_id string
param stripped_uid string = replace(string(newGuid()), '-', '')

resource linux_vm_name_resource 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: linux_vm_name
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
        //name: '${linux_vm_name}_OsDisk_1_8124a9cc57b94caeb4b68b0be6e68e7f'
        name: '${linux_vm_name}${stripped_uid}'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        // managedDisk: {
        //   id: managed_disk_id
        // }
        deleteOption: 'Delete'
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: linux_vm_name
      adminUsername: vm_admin_user
      adminPassword: vm_admin_pwd
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
      // requireGuestProvisionSignal: true
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
          id: nic_id
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
