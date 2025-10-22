#!/bin/bash

# ==========================================
# GROUP 1 CAPSTONE CONNECTIVITY CHECK SCRIPT
# Lists all VM IPs and verifies connectivity
# ==========================================

# Variables
RG="Group1ResourceGroup"
ADMIN_USER="dukeyico"

echo "=============================================="
echo "GROUP 1 CONNECTIVITY TEST (UK South)"
echo "Resource Group: $RG"
echo "=============================================="
echo ""

# List all VM IP addresses
echo "Fetching all VM IP addresses..."
az vm list-ip-addresses -g $RG -o table
echo ""

# Capture IPs for each VM
WEB_IP=$(az vm list-ip-addresses -g $RG -n WebVM --query "[0].virtualMachine.network.publicIpAddresses[0].ipAddress" -o tsv)
APP_PRIV_IP=$(az vm list-ip-addresses -g $RG -n AppVM --query "[0].virtualMachine.network.privateIpAddresses[0]" -o tsv)
DB_PRIV_IP=$(az vm list-ip-addresses -g $RG -n DBVM --query "[0].virtualMachine.network.privateIpAddresses[0]" -o tsv)

echo " WebVM Public IP:  $WEB_IP"
echo " AppVM Private IP: $APP_PRIV_IP"
echo " DBVM Private IP:  $DB_PRIV_IP"
echo ""

# Test SSH connection to WebVM
echo "Testing SSH connection to WebVM..."
ssh -o ConnectTimeout=10 $ADMIN_USER@$WEB_IP "echo 'Connected to WebVM successfully'; hostname"
if [ $? -ne 0 ]; then
    echo "SSH connection to WebVM failed! Check NSG rules or IP address."
    exit 1
fi
echo ""

# Test ping from WebVM → AppVM and DBVM
echo "Testing internal subnet connectivity from WebVM..."
ssh -o ConnectTimeout=10 $ADMIN_USER@$WEB_IP <<EOF
echo "----------------------------------------------"
echo "🔹 Pinging AppVM ($APP_PRIV_IP)"
ping -c 4 $APP_PRIV_IP
echo ""
echo "🔹 Pinging DBVM ($DB_PRIV_IP)"
ping -c 4 $DB_PRIV_IP
echo "----------------------------------------------"
EOF

echo ""
echo "Connectivity check complete!"
echo "   - WebVM SSH access working"
echo "   - Web → App and Web → DB ping tests completed"
echo ""
echo "Take screenshots of these results for your report."
