// Add parameter 'globalRedundancy'
param globalRedundancy bool = false

var location = resourceGroup().location

param environmentName string {
  allowed: [
    'Prod'
    'DR'
  ]
}

var sku = environmentName == 'Prod' ? 'Standard_GRS' : 'Standard_LRS'
var namePrefix = 'stg'

// 'namePrefix' will be concatenated to the storage group name.
resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: '${namePrefix}${uniqueString(resourceGroup().id)}'
  location: location
  kind: 'Storage'
  // 4. If boolean 'globalRedundancy' is true, use 'Standard_GRS'; else use 'Standard_LRS'
  sku: {
    name: globalRedundancy ? 'Standard_GRS' : 'Standard_LRS'
  }
}
//Network related data
param vnetHUBName string {
  metadata: {
    description: 'Name of Hub Virtual network'
  }
}

var vnetHUBConfig = {
  vnetprefix: '10.130.0.0/21'
  subnet0: {
    name: 'Untrust'
    addressPrefix: '10.130.0.0/24'
  }
  subnet1: {
    name: 'Trust'
    addressPrefix: '10.130.1.0/24'
  }
  subnet2: {
    name: 'GWTransit'
    addressPrefix: '10.130.2.0/24'
  }
}

param vnetSPOKEName string {
  metadata: {
    description: 'Name of SPOKE Virtual network'
  }
}
var vnetSPOKEConfig = {
  vnetprefix: '10.131.0.0/21'
  subnet0: {
    name: 'ProdNet1'
    addressPrefix: '10.131.0.0/24'
  }
  subnet1: {
    name: 'ProdNet2'
    addressPrefix: '10.131.1.0/24'
  }
  subnet2: {
    name: 'ProdNet3'
    addressPrefix: '10.131.2.0/24'
  }
}

resource nsghub 'Microsoft.Network/networkSecurityGroups@2020-05-01' = {
  name: 'nsgTrust'
  location: location
  properties: {
    securityRules: [
      {
        name: 'inbound_VNet'
        id: '100'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '10.130.0.0/21'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          protocol: '*'
        }
      }
      {
        name: 'inbound_Deny'
        id: '110'
        properties: {
          priority: 110
          access: 'Deny'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          protocol: '*'
        }
      }
      {
        name: 'outbound_VNet'
        id: '100'
        properties: {
          priority: 100
          access: 'Allow'
          direction: 'Outbound'
          sourceAddressPrefix: '10.130.0.0/21'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          protocol: '*'
        }
      }
      {
        name: 'outbound_Deny'
        id: '110'
        properties: {
          priority: 110
          access: 'Deny'
          direction: 'Outbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '*'
          protocol: '*'
        }
      }
    ]
  }
}

resource vnethub 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetHUBName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetHUBConfig.vnetprefix
      ]
    }
    subnets: [
      {
        name: vnetHUBConfig.subnet0.name
        properties: {
          addressPrefix: vnetHUBConfig.subnet0.addressPrefix
          networkSecurityGroup: {
            id: nsghub.id
          }
        }
      }
      {
        name: vnetHUBConfig.subnet1.name
        properties: {
          addressPrefix: vnetHUBConfig.subnet1.addressPrefix
          networkSecurityGroup: {
            id: nsghub.id
          }
        }
      }
      {
        name: vnetHUBConfig.subnet2.name
        properties: {
          addressPrefix: vnetHUBConfig.subnet2.addressPrefix
          networkSecurityGroup: {
            id: nsghub.id
          }
        }
      }
    ]
  }
}

resource vnetspoke 'Microsoft.Network/virtualNetworks@2020-06-01' = {
  name: vnetSPOKEName
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        vnetSPOKEConfig.vnetprefix
      ]
    }
    subnets: [
      {
        name: vnetSPOKEConfig.subnet0.name
        properties: {
          addressPrefix: vnetSPOKEConfig.subnet0.addressPrefix
          networkSecurityGroup: {
            id: nsghub.id
          }
        }
      }
      {
        name: vnetSPOKEConfig.subnet1.name
        properties: {
          addressPrefix: vnetSPOKEConfig.subnet1.addressPrefix
          networkSecurityGroup: {
            id: nsghub.id
          }
        }
      }
      {
        name: vnetSPOKEConfig.subnet2.name
        properties: {
          addressPrefix: vnetSPOKEConfig.subnet2.addressPrefix
          networkSecurityGroup: {
            id: nsghub.id
          }
        }
      }
    ]
  }
}