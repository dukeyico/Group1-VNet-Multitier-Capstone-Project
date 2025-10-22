# Group 1 – Deployment Steps (UK South)
## Project Title:
**Deploy a VNet-Based Multi-Tier Architecture and Enforce Access Control**

**Region:** UK South (`uksouth`)  
**Resource Group:** `Group1ResourceGroup`    

---

## Project Overview

This deployment creates a **3-tier Azure infrastructure** consisting of:
- A **Virtual Network (VNet)** divided into 3 subnets: Web, App, and DB.
- **Linux Virtual Machines** in each subnet.
- **Network Security Groups (NSGs)** enforcing secure access between tiers:
  - Internet → Web (HTTP & SSH)
  - Web → App (HTTP)
  - App → DB (MySQL/Port 3306)
- Only the **Web tier** has a **Public IP**, ensuring external access is restricted and controlled.

---

## Pre-requisites

- Active Azure subscription with permission to deploy in `uksouth`.
- Azure CLI installed (or use **Azure Cloud Shell**).
- GitHub repository to store scripts and documentation.
- SSH client for connecting to deployed VMs.

---

## Deployment Script Setup

The main deployment file used is:

> `scripts/group1_multitier_deploy.sh`

This Bash script automates the entire process of:
- Resource group creation  
- Network & subnet setup  
- NSG creation and rule configuration  
- VM deployment  
- Public IP association  
- Connectivity verification  

---

## Step-by-Step Deployment Procedure

### **Step 1: Create Resource Group**
```bash
az group create --name Group1ResourceGroup --location uksouth
```
---

### Step 2: Create Virtual Network and Subnets
```bash
az network vnet create -g Group1ResourceGroup -n Group1VNet --address-prefix 10.0.0.0/16 --subnet-name WebSubnet --subnet-prefix 10.0.1.0/24
az network vnet subnet create -g Group1ResourceGroup --vnet-name Group1VNet -n AppSubnet --address-prefix 10.0.2.0/24
az network vnet subnet create -g Group1ResourceGroup --vnet-name Group1VNet -n DBSubnet --address-prefix 10.0.3.0/24
```

---

### Step 3: Create NSGs and Add Security Rules

Each subnet has its own NSG:
- WebNSG: Allows HTTP (80) and SSH (22) from the internet.

- AppNSG: Allows HTTP (80) and SSH (22) from Web subnet (10.0.1.0/24).

- DBNSG: Allows MySQL (3306) and SSH (22) from App subnet (10.0.2.0/24).

Example command:
```bash
az network nsg rule create -g Group1ResourceGroup --nsg-name AppNSG -n AllowWebToApp --priority 100 --protocol Tcp --source-address-prefixes 10.0.1.0/24 --destination-port-ranges 80 --access Allow --direction Inbound
```
---

### Step 4: Create NICs and Attach NSGs
```bash
az network nic create -g Group1ResourceGroup -n WebNIC --vnet-name Group1VNet --subnet WebSubnet --network-security-group WebNSG
az network nic create -g Group1ResourceGroup -n AppNIC --vnet-name Group1VNet --subnet AppSubnet --network-security-group AppNSG
az network nic create -g Group1ResourceGroup -n DbNIC  --vnet-name Group1VNet --subnet DBSubnet  --network-security-group DBNSG
```
---

### Step 5: Create a Public IP for Web Tier
```bash
az network public-ip create -g Group1ResourceGroup -n WebVMPublicIP --sku Standard --allocation-method Static
az network nic ip-config update -g Group1ResourceGroup --nic-name WebNIC --name ipconfig1 --public-ip-address WebVMPublicIP
```
---

### Step 6: Deploy the Linux VMs
```bash
az vm create -g Group1ResourceGroup -n WebVM --nics WebNIC --image Ubuntu2204 --size Standard_B1s --admin-username dukeyico --admin-password '@Deukffjfieeow' --public-ip-sku Standard --location uksouth

az vm create -g Group1ResourceGroup -n AppVM --nics AppNIC --image Ubuntu2204 --size Standard_B1s --admin-username dukeyico --admin-password '@Deukffjfieeow' --location uksouth

az vm create -g Group1ResourceGroup -n DBVM --nics DbNIC --image Ubuntu2204 --size Standard_B1s --admin-username dukeyico --admin-password '@Deukffjfieeow' --location uksouth
```
---

### Step 7: Verify Deployment

List all IPs:
```bash
az vm list-ip-addresses -g Group1ResourceGroup -o table
```
Example result:
```
Name    PrivateIPAddresses  PublicIPAddresses
------  ------------------  -----------------
WebVM   10.0.1.4            20.75.19.110
AppVM   10.0.2.4
DBVM    10.0.3.4
```
---

### Step 8: Test Connectivity

SSH into WebVM:
```
ssh dukeyico@20.75.19.110
```
Ping App and DB from WebVM:
```bash
ping -c 4 10.0.2.4
ping -c 4 10.0.3.4
```
