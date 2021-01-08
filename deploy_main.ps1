#!/usr/bin/env pwsh

New-AzResourceGroup -Location australiaeast -Name RG-NET-HUB -Force
New-AzResourceGroup -Location australiaeast -Name RG-NET-SPOKE -Force

New-AzDeployment -Name "bicepNetProvisionDemo" `
    -Location australiaeast `
    -TemplateFile .\main.json `
    -rg1Name RG-NET-HUB `
    -vnet1Name VNETHUB `
    -rg2Name RG-NET-SPOKE `
    -vnet2Name VNETSPOKE `
    -nsgHubName nsgHUB `
    -nsgSpokeName nsgSPOKE
