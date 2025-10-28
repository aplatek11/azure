# Install the Microsoft Graph PowerShell SDK module if not already installed
# Install-Module Microsoft.Graph -Scope CurrentUser

# Connect to Microsoft Graph with the necessary permissions
# The "Organization.Read.All" permission is required to view license details.
Connect-MgGraph -Scopes "Organization.Read.All"

# Get all subscribed SKUs (license plans) for the tenant
$subscribedSkus = Get-MgSubscribedSku

# Display details of each subscribed SKU
Write-Host "--- Azure License Plans ---"
foreach ($sku in $subscribedSkus) {
    Write-Host "SKU Part Number: $($sku.SkuPartNumber)"
    Write-Host "  Enabled Units: $($sku.Enabled)"
    Write-Host "  Consumed Units: $($sku.ConsumedUnits)"
    Write-Host "  Service Plans:"
    foreach ($servicePlan in $sku.ServicePlans) {
        Write-Host "    - $($servicePlan.ServicePlanName) (Status: $($servicePlan.ProvisioningStatus))"
    }
    Write-Host ""
}

# Optional: List users with assigned licenses
Write-Host "--- Licensed Users ---"
Get-MgUser -Filter 'assignedLicenses/$count ne 0' -ConsistencyLevel eventual -CountVariable licensedUserCount -All -Select UserPrincipalName, DisplayName, AssignedLicenses | Format-Table -Property UserPrincipalName, DisplayName, AssignedLicenses
Write-Host "Found $licensedUserCount licensed users."

# Optional: List users without assigned licenses
Write-Host "--- Unlicensed Users ---"
Get-MgUser -Filter 'assignedLicenses/$count eq 0' -ConsistencyLevel eventual -CountVariable unlicensedUserCount -All -Select UserPrincipalName, DisplayName | Format-Table -Property UserPrincipalName, DisplayName
Write-Host "Found $unlicensedUserCount unlicensed users."

# Disconnect from Microsoft Graph
#Disconnect-MgGraph