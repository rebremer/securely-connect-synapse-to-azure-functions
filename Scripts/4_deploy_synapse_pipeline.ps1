# 0.1 Load variables
. ./0_variables.ps1

# 0.2 log in
az login --tenant $tenant_id
az account set --subscription $sub

# 1. Deploy Synapse pipeline
$function_key = (az functionapp function keys list -g $rg -n $fun_name --function-name $HTTPTrigger_name | ConvertFrom-Json).default
$url = "https://" + $fun_name + ".azurewebsites.net/api/" + $HTTPTrigger_name + "?code=" + $function_key + "&name=rene"
#
$resource = (az webapp auth microsoft show -n $fun_name -g $rg | ConvertFrom-Json).validation.allowedAudiences[0]
$pipeline = (Get-Content "../ADF/pipeline_webactivity_AzureFunction.json" -Raw) -replace '@pipeline\(\).parameters.function_url', "$url" -replace '@pipeline\(\).parameters.function_resource', "$resource"

$pipeline = $pipeline -replace "`n","" -replace "`r","" -replace " ","" -replace '"','\"'
az synapse pipeline create --workspace-name $synapse_name --name "Webactivity_AzureFunction2" --file $pipeline #"pipeline_webactivity_AzureFunction.json"
cd ../Scripts