#!/bin/bash

# ==========================================
# GROUP 1 CAPSTONE CLEANUP SCRIPT
# Deletes all Azure resources created for demo
# ==========================================

# Variables
RG="Group1_ResourceGroup"   # Resource Group name
LOC="uksouth"              # Region (for information only)

echo "=============================================="
echo " CLEANUP SCRIPT GROUP 1 CAPSTONE (UK South)"
echo "This will delete all resources in resource group: $RG"
echo "Location: $LOC"
echo "=============================================="
echo ""

# Confirm before deleting
read -p "  Are you sure you want to delete ALL resources in $RG? (y/n): " confirm

if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
    echo "Deleting Resource Group '$RG'..."
    az group delete --name $RG --yes --no-wait
    echo "Deletion initiated. Resources will be removed in the background."
    echo "Use this command to check status:"
    echo "   az group list -o table"
else
    echo "Deletion canceled. No resources were removed."
fi
