param location string = '${resourceGroup().location}'
param nsgName string
param nsgHubRules array

resource nsghub 'Microsoft.Network/networkSecurityGroups@2020-06-01' = {
  name: nsgName
  location: location
  properties: {
    securityRules: nsgHubRules
  }
}