# ============================
# Variables
# ============================
$subscriptionId = "ea15fdad-b328-4ae9-97d9-01a95dea2d15"
$resourceGroup  = "sentinel-rg"
$dcrName        = "prod-pullrequest-dcr"
$identityId     = "02c03395-5171-4cff-909f-e013abc9e97c"   # System-assigned MI objectId

# ============================
# Get DCR Resource ID
# ============================
$dcr = az monitor data-collection rule show `
    --name $dcrName `
    --resource-group $resourceGroup `
    --subscription $subscriptionId `
    --query id -o tsv

if (-not $dcr) {
    Write-Host "ERROR: DCR '$dcrName' not found in resource group '$resourceGroup'." -ForegroundColor Red
    exit 1
}

Write-Host "DCR Resource ID:" $dcr -ForegroundColor Cyan

# ============================
# Assign Contributor Role
# ============================
Write-Host "Assigning Contributor role..." -ForegroundColor Yellow

az role assignment create `
    --assignee $identityId `
    --role "Contributor" `
    --scope $dcr `
    --subscription $subscriptionId

# ============================
# Assign Monitoring Metrics Publisher Role
# ============================
Write-Host "Assigning Monitoring Metrics Publisher role..." -ForegroundColor Yellow

az role assignment create `
    --assignee $identityId `
    --role "Monitoring Metrics Publisher" `
    --scope $dcr `
    --subscription $subscriptionId

# ============================
# Done
# ============================
Write-Host "Role assignments completed successfully." -ForegroundColor Green
