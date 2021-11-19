#!/bin/bash

set -o errexit
set -o pipefail
set -o nounset
set -o xtrace # For debugging

###################
# REQUIRED ENV VARIABLES:
#
# PROJECT
# DEPLOYMENT_ID
# ENV_NAME
# AZURE_LOCATION
# AZURE_SUBSCRIPTION_ID
# POWERBI_WORKSPACE_ID

#####################

#####################
# DEPLOY ARM TEMPLATE

# Set account to where ARM template will be deployed to
echo "Deploying to Subscription: $AZURE_SUBSCRIPTION_ID"
az account set --subscription "$AZURE_SUBSCRIPTION_ID"

# Create resource group
resource_group_name="rg-$PROJECT-$DEPLOYMENT_ID-$ENV_NAME"
echo "Creating resource group: $resource_group_name"
az group create --name "$resource_group_name" --location "$AZURE_LOCATION" --tags Environment="$ENV_NAME"


# Validate arm template

echo "Validating deployment"
arm_output=$(az deployment group validate \
    --resource-group $resource_group_name \
    --template-file ./infrastructure/main.bicep \
    --parameters project=$PROJECT env=$ENV_NAME deployment_id=$DEPLOYMENT_ID pbiGroupId=$POWERBI_WORKSPACE_ID  \
    --output json)

# Deploy arm template
echo "Deploying resources into $resource_group_name"
arm_output=$(az deployment group create \
    --resource-group $resource_group_name \
    --template-file ./infrastructure/main.bicep \
    --parameters project=$PROJECT env=$ENV_NAME deployment_id=$DEPLOYMENT_ID pbiGroupId=$POWERBI_WORKSPACE_ID  \
    --output json)


# ########################

echo "Deploying resources complete"