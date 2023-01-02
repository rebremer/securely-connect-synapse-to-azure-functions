# 0.1 Load variables
. ./0_variables.ps1

$private_endpoint = (Get-Content "../ADF/AzureFunction_private_endpoint.json" -Raw)
$private_endpoint = $private_endpoint -replace "@sub", "$sub" -replace "@fun_name", "$fun_name" -replace "@rg", "$rg" 
$private_endpoint = $private_endpoint -replace "`n","" -replace "`r","" -replace " ","" -replace '"','\"'

az synapse managed-private-endpoints create --workspace-name $synapse_name --pe-name ($fun_name + "_pe2") --file $private_endpoint
Start-Sleep 60
$id = (az network private-endpoint-connection list -g $rg -n $fun_name --type Microsoft.Web/sites | ConvertFrom-Json)[0].id
az network private-endpoint-connection approve --id $id --description "Approved"
