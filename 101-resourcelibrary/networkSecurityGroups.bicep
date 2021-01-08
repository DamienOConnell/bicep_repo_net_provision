param location string = '${resourceGroup().location}'

resource nsghub 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
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