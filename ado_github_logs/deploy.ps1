# ================================
#  Azure Login + ARM Deployment
#  For master-template.json
# ================================

# Load parameter file
$paramFile = "./master-parameters.json"

if (-Not (Test-Path $paramFile)) {
    Write-Host "Parameter file not found: $paramFile" -ForegroundColor Red
    exit 1
}

$params = Get-Content -Raw -Path $paramFile | ConvertFrom-Json

$subscriptionId     = $params.parameters.subscriptionId.value
$tenantId           = $params.parameters.tenantId.value
$resourceGroupName  = $params.parameters.resourceGroupName.value

# -------------------------------
#  Login to Azure
# -------------------------------
Write-Host "Signing into Azure..." -ForegroundColor Cyan

Connect-AzAccount -Tenant $tenantId
Set-AzContext -Subscription $subscriptionId

Write-Host "Authenticated successfully." -ForegroundColor Green

# -------------------------------
#  Deploy ARM Template
# -------------------------------
Write-Host "Starting ARM template deployment..." -ForegroundColor Cyan

New-AzResourceGroupDeployment `
    -ResourceGroupName $resourceGroupName `
    -TemplateFile "./master-template.json" `
    -TemplateParameterFile $paramFile `
    -Verbose

Write-Host "Deployment complete." -ForegroundColor Green
