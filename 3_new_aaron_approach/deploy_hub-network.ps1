#!/usr/bin/env pwsh

New-AzResourceGroup -Location australiaeast -Name RG-NET-HUB -Force

New-AzResourceGroupDeployment `
    -Name "bicepNetProvisionDemo" `
    -ResourceGroupName RG-NET-HUB `
    -Location australiaeast `
    -TemplateFile .\hub-network.json