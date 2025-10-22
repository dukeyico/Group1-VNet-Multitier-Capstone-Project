# Group 1 – Deployment Steps (UK South)
## Project Title:
**Deploy a VNet-Based Multi-Tier Architecture and Enforce Access Control**

**Region:** UK South (`uksouth`)  
**Resource Group:** `Group1CapstoneRG_UK`    

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

> **`scripts/group1_multitier_deploy.sh`**

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

---

### **Step 2: Create Virtual Network and Subnets**
```bash
az network vnet create -g Group1CapstoneRG_UK -n Group1VNet --address-prefix 10.0.0.0/16 --subnet-name WebSubnet --subnet-prefix 10.0.1.0/24
az network vnet subnet create -g Group1CapstoneRG_UK --vnet-name Group1VNet -n AppSubnet --address-prefix 10.0.2.0/24
az network vnet subnet create -g Group1CapstoneRG_UK --vnet-name Group1VNet -n DBSubnet --address-prefix 10.0.3.0/24

---

### Step 3: Create NSGs and Add Security Rules

Each subnet has its own NSG:
- WebNSG: Allows HTTP (80) and SSH (22) from the internet.

- AppNSG: Allows HTTP (80) and SSH (22) from Web subnet (10.0.1.0/24).

- DBNSG: Allows MySQL (3306) and SSH (22) from App subnet (10.0.2.0/24).

Example command:

az network nsg rule create -g Group1CapstoneRG_UK --nsg-name AppNSG -n AllowWebToApp --priority 100 --protocol Tcp --source-address-prefixes 10.0.1.0/24 --destination-port-ranges 80 --access Allow --direction Inbound
