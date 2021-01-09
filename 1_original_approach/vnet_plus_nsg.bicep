// scope is the subscription name
// This will be a single vNet with NSGs

targetScope = 'Main'

param rg1Name string
param rg1Location string = 'australiaeast'
param vnet1Name string

resource rg1 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${rg1Name}'
  location: '${rg1Location}'
}

// module vnet1 './101-resourcelibrary/virtualNetwork2Subnets.bicep' = {
//   name: 'vnet1'
//   scope: resourceGroup(rg1.name)
//   dependsOn: [
//     // nsgHub1
//   ]
//   params: {
//     vnetName: vnet1Name
//     addressPrefixes: [
//       '10.130.0.0/21'
//     ]
//     subnet1Name: 'd-sne${vnet1Name}-01'
//     subnet2Name: 'd-sne${vnet1Name}-02'
//     subnet1AddressPrefix: '10.130.0.0/24'
//     subnet2AddressPrefix: '10.130.1.0/24'
//     // subnetNSG: nsgHub1
//   }
// }

module nsgHub1 './101-resourcelibrary/networkSecurityGroups.bicep' = {
  name: 'nsgHub1'
  scope: resourceGroup(rg1.name)
  dependsOn: []
  params: {}
}