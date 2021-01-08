// scope is the subscription name
targetScope = 'Main'

param rg1Name string
param rg1Location string = 'australiaeast'
param rg2Name string
param rg2Location string = 'australiaeast'
param vnet1Name string
param vnet2Name string

resource rg1 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${rg1Name}'
  location: '${rg1Location}'
}

resource rg2 'Microsoft.Resources/resourceGroups@2020-06-01' = {
  name: '${rg2Name}'
  location: '${rg2Location}'
}

module vnet1 './101-resourcelibrary/virtualNetwork2Subnets.bicep' = {
  name: 'vnet1'
  scope: resourceGroup(rg1.name)
  dependsOn: [
    // nsgHub1
  ]
  params: {
    vnetName: vnet1Name
    addressPrefixes: [
      '10.130.0.0/21'
    ]
    subnet1Name: 'd-sne${vnet1Name}-01'
    subnet2Name: 'd-sne${vnet1Name}-02'
    subnet1AddressPrefix: '10.130.0.0/24'
    subnet2AddressPrefix: '10.130.1.0/24'
  }
}

module vnet2 './101-resourcelibrary/virtualNetwork2Subnets.bicep' = {
  name: 'vnet2'
  scope: resourceGroup(rg2.name)
  params: {
    vnetName: vnet2Name
    addressPrefixes: [
      '10.131.0.0/21'
    ]
    subnet1Name: 'd-sne${vnet2Name}-01'
    subnet2Name: 'd-sne${vnet2Name}-02'
    subnet1AddressPrefix: '10.131.0.0/24'
    subnet2AddressPrefix: '10.131.1.0/24'
  }
}

module peering1 './101-resourcelibrary/vnetPeering.bicep' = {
  name: 'peering1'
  scope: resourceGroup(rg1.name)
  dependsOn: [
    vnet1
    vnet2
  ]
  params: {
    localVnetName: vnet1Name
    remoteVnetName: vnet2Name
    remoteVnetRg: rg2Name
  }
}

module peering2 './101-resourcelibrary/vnetPeering.bicep' = {
  name: 'peering2'
  scope: resourceGroup(rg2.name)
  dependsOn: [
    vnet2
    vnet1
  ]
  params: {
    localVnetName: vnet2Name
    remoteVnetName: vnet1Name
    remoteVnetRg: rg1Name
  }
}

module nsgHub1 './101-resourcelibrary/networkSecurityGroups.bicep' = {
  name: 'nsgHub1'
  scope: resourceGroup(rg1.name)
  dependsOn: []
  params: {}
}

module nsgSpoke1 './101-resourcelibrary/networkSecurityGroups.bicep' = {
  name: 'nsgSpoke1'
  scope: resourceGroup(rg2.name)
  dependsOn: []
  params: {}
}