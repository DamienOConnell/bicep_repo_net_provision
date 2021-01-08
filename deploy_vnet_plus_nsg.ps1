#!/usr/bin/env pwsh

New-AzResourceGroup -Location australiaeast -Name RG-NET-HUB -Force

# Using New-AzDeployment:
#
# New-AzDeployment -Name "bicepNetProvisionDemo" `
#     -Location australiaeast `
#     -TemplateFile .\vnet_plus_nsg.json `
#     -rg1Name RG-NET-HUB `
#     -vnet1Name VNETHUB

# Using New-AzResourceGroupDeployment:
#
New-AzResourceGroupDeployment `
    -Name "bicepNetProvisionDemo" `
    -ResourceGroupName RG-NET-HUB `
    -TemplateFile .\vnet_plus_nsg.json `
    -rg1Name RG-NET-HUB `
    -vnet1Name VNETHUB `
    -Force
    