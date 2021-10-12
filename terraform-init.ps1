<#
    .SYNOPSIS
    This script generates a password
    .DESCRIPTION
    Runs Terraform init using the azurerm backend configuration, and saves the state file in an Azure storage account
    .PARAMETER azure_credentials
    Azure_Credentials in JSON format
    https://github.com/marketplace/actions/azure-cli-action#configure-azure-credentials-as-github-secret
    .PARAMETER storage_account_name
    State file - Storage Account Name
    .PARAMETER container_name
    State file - Container Name
    .PARAMETER resource_group_name
    State file - Resource Group Name
    .PARAMETER file_name
    State file - State File name
    .PARAMETER directory
    Terraform working directory
    .NOTES
    Written by Ahmed Elsayed
    @ahmedig
    https://www.linkedin.com/in/ahmedig/
    #>
param(
    [parameter(Mandatory = $true)]
    $azure_credentials,
    [parameter(Mandatory = $true)]
    [string]$storage_account_name,
    [parameter(Mandatory = $true)]
    [string]$container_name,
    [parameter(Mandatory = $true)]
    [string]$resource_group_name,
    [parameter(Mandatory = $true)]
    [string]$file_name,
    [parameter(Mandatory = $true)]
    [string]$directory
)
pushd $directory
Get-Location

Write-Host "starting action"
$azure_creds = $azure_credentials | ConvertFrom-Json
terraform version
terraform init -reconfigure -input=false -backend-config=storage_account_name=$storage_account_name -backend-config=container_name=$container_name -backend-config=key=$file_name -backend-config=resource_group_name=$resource_group_name
# terraform init -backend-config=storage_account_name=$(STORAGE_ACCOUNT_NAME) -backend-config=container_name=$(CONTAINER_NAME) -backend-config=resource_group_name=$(RESOURCE_GROUP_NAME) -backend-config=key=aks_spns.tfstate -reconfigure


# Return password to workflow
# echo "::set-output name=password::$GeneratedPassword"
popd