📘 Deploying the Sentinel Ingestion ARM Template
This repository contains a fully parameterized Azure Resource Manager (ARM) template for deploying:

A Data Collection Endpoint (DCE)

A Sentinel Custom Table

A Data Collection Rule (DCR) wired to the workspace and DCE

All environment‑specific values (subscription, tenant, workspace, region, etc.) are stored in a parameter file, keeping the ARM template reusable and safe to publish.

📁 Files Included
1. master-template.json
The main ARM template. It defines:

Data Collection Endpoint

Sentinel custom table

Data Collection Rule

Stream schema

KQL transform

Log Analytics destination

This file contains no sensitive information and is safe to commit publicly.

2. master-parameters.json
A parameter file containing blank values that users must fill in before deployment.

Each parameter includes a description explaining what to enter.

⚠️ Never commit your real parameter values to GitHub.  
Create a private copy (e.g., master-parameters.local.json) for actual deployments.

🛠️ Updating the Parameter File
Open master-parameters.json and fill in each value:

json
"subscriptionId": {
  "value": "YOUR-SUBSCRIPTION-ID"
},
"tenantId": {
  "value": "YOUR-TENANT-ID"
},
"resourceGroupName": {
  "value": "YOUR-RESOURCE-GROUP"
},
"workspaceName": {
  "value": "YOUR-WORKSPACE-NAME"
},
"DCEName": {
  "value": "YOUR-DCE-NAME"
},
"DCRName": {
  "value": "YOUR-DCR-NAME"
},
"Region": {
  "value": "YOUR-AZURE-REGION"
}
✔ Example region values
eastus

westus2

southeastasia

uksouth

✔ Example workspace name
Sentinel-Lab

✔ Example DCE/DCR names
prod-sentinel-dce

prod-githublogs

🚀 Deployment Options
You can deploy this ARM template using either the Azure Portal or PowerShell.

Option 1 — Deploy via Azure Portal (Recommended)
Open the Azure Portal

Search for “Deploy a custom template”

Select Build your own template in the editor

Upload master-template.json

Click Next

Upload master-parameters.json or manually enter values

Click Review + Create

Azure will deploy:

The Data Collection Endpoint

The Sentinel custom table

The Data Collection Rule

All associations

Option 2 — Deploy via PowerShell
Authenticate:

powershell
Connect-AzAccount
Set-AzContext -Subscription "<your-subscription-id>"
Deploy:

powershell
New-AzResourceGroupDeployment `
  -ResourceGroupName "<your-resource-group>" `
  -TemplateFile "./master-template.json" `
  -TemplateParameterFile "./master-parameters.json"
🧩 Optional Template Customizations
You may modify the ARM template if needed:

✔ Table name
json
"name": "GitHubLogs_CL"
✔ Stream name
json
"Custom-GitHubLogs_CL"
✔ Schema columns
Modify the "columns" array under:

streamDeclarations

schema

✔ KQL transform
Currently:

json
"transformKql": "source"
Replace "source" with any KQL expression.

🛡️ Security Notes
The ARM template contains no sensitive data

The parameter file contains blank values

Users must fill in their own IDs locally

Never commit real subscription IDs, tenant IDs, or workspace names

Add this to .gitignore to prevent accidental commits:

Code
master-parameters.local.json
*.local.json