# 0.1 Load variables
. ./0_variables.ps1

# 0.2 log in
az login --tenant $tenant_id
az account set --subscription $sub         

# 1. Create resource group
az group create -n $rg -l $loc

# 1. Create Synapse Workspace with data exfiltration protection enabled
az storage account create -n $synapse_stor -g $rg -l $loc --sku Standard_LRS --kind StorageV2
$user = (-join([char[]](97..122) | Get-Random -Count 10))
$password = (-join([char[]](33..122) | Get-Random -Count 30))
az synapse workspace create -n $synapse_name -g $rg --storage-account $synapse_stor --file-system "testfilesystem" --location $loc --enable-managed-vnet true --prevent-exfiltration true --sql-admin-login-user "$user" --sql-admin-login-password "$password"
$user = ""
$password = ""

# Don't do this in production, use VPN or client IP address to connect to Synapse
az synapse workspace firewall-rule create --name allowAll --workspace-name $synapse_name --resource-group $rg --start-ip-address 0.0.0.0 --end-ip-address 255.255.255.255

# 2. Create Azure Function
az functionapp plan create -g $rg -n $fun_app_plan --sku B1 --is-linux true          
az storage account create -n $fun_stor -g $rg -l $loc --sku Standard_LRS --kind StorageV2                   
az functionapp create -n $fun_name -g $rg -s $fun_stor -p $fun_app_plan --assign-identity --runtime Python
Start-Sleep 60                          
cd ../AzureFunction
func azure functionapp publish $fun_name
cd ../Scripts