#!/usr/bin/env pwsh

New-AzResourceGroup -Location australiaeast -Name RG-CORENET -Force
New-AzResourceGroup -Location australiaeast -Name RG-SPOKENET -Force

New-AzDeployment -Name "bicepNetProvisionDemo" `
    -Location australiaeast `
    -TemplateFile .\main.json `
    -rg1Name RG-CORENET `
    -vnet1Name VNETCORE `
    -rg2Name RG-HUBNET `
    -vnet2Name VNETSPOKE