[CmdletBinding()]
param (
  # The User Managed Identity Client ID.
  [Parameter()]
  [String]
  $UMIId,

  # The Subscription ID of the Tenant
  [Parameter()]
  [String]
  $SubscriptionId,

  # The Workspace Name where the Sentinel instance resides.
  [Parameter()]
  [String]
  $workspaceName,

  # The Resource Group Name where the Sentinel instance resides.
  [Parameter()]
  [String]
  $resourceGroup,

  # The Logic App URI that will retriece the values.
  [Parameter()]
  [String]
  $pricingTierApi
)

# Retrieve variables from Automation Account if not passed in as parameters
if ([string]::IsNullOrWhiteSpace($UMIId)) {
  $UMIId = Get-AutomationVariable -Name 'UMI_ID'
}
if ([string]::IsNullOrWhiteSpace($SubscriptionId)) {  
  $SubscriptionId = Get-AutomationVariable -Name 'SUBSCRIPTION_ID'
}
if ([string]::IsNullOrWhiteSpace($workspaceName)) {
  $workspaceName = Get-AutomationVariable -Name 'WORKSPACE_NAME'
}
if ([string]::IsNullOrWhiteSpace($resourceGroup)) {
  $resourceGroup = Get-AutomationVariable -Name 'RESOURCE_GROUP_NAME'
}
if ([string]::IsNullOrWhiteSpace($pricingTierLaUri)) {
  $pricingTierApi = Get-AutomationVariable -Name 'PRICINGTIER_API'
}

# Authenticate to Azure using the specified User Managed Identity
Connect-AzAccount -Identity -AccountId $UMIId

# Set the subscription context for subsequent Az cmdlets
Set-AzContext -SubscriptionId $SubscriptionId

# Retrieve the Sentinel workspace object
$workspace = Get-AzOperationalInsightsWorkspace -ResourceGroupName $resourceGroup -Name $workspaceName

# Determine the pricing tier based on the workspace S
switch ($workspace.Sku) {
    "PerGB2018" {
        $PriceTier = "Pay-As-You-Go"
    }
    "CapacityReservation" {
        $PriceTier = "$($workspace.CapacityReservationLevel) GB"
    }
    default {
        $PriceTier = "Pricing Tier is Unknown"
    }
}

# Construct the JSON payload to send to the Logic App
  $jsonBody = @{
    PricingTier     = $PriceTier
    WorkspaceName   = $($workspace.Name)
} | ConvertTo-Json -Depth 3

# Send the JSON payload to Logic App
Invoke-RestMethod -Method Post -Uri $pricingTierApi -Body $jsonBody -ContentType "application/json"