# Group 1 — VNet-Based Multi-Tier Architecture (Web → App → DB)

**Project:** Deploy a VNet-based multi-tier architecture and enforce access control  
**Group:** Group 1  
**Leader:** Duke (dukeyico)  
**Region used:** UK South (uksouth)  
**Submission:** GitHub repository + documentation + screenshots + demo

---

## Overview
This project builds a secure 3-tier cloud network on Azure:
- **Web subnet (frontend)** — publicly reachable (HTTP/SSH)
- **App subnet (application)** — reachable only from Web subnet
- **DB subnet (database)** — reachable only from App subnet

All resources are deployed using the included **Bash automation script** [`Scripts/group1_multitier_deploy.sh`](Scripts/group1_multitier_deploy.sh) which uses Azure CLI.

---

## Architecture
(see [`docs/architecture-diagram.png`](docs/architecture-diagram.png) for a labeled diagram)

Key components:
- Virtual Network: `Group1VNet` (10.0.0.0/16)
- Subnets: `WebSubnet` (10.0.1.0/24), `AppSubnet` (10.0.2.0/24), `DBSubnet` (10.0.3.0/24)
- NSGs: `WebNSG`, `AppNSG`, `DBNSG` with rules enforcing Web → App → DB flows
- VMs: `WebVM` (public IP), `AppVM`, `DBVM` (private IPs)
- Public IP: `WebVMPublicIP` (static)

---

## How to run (Cloud Shell / local az CLI)
1. Open Azure Cloud Shell (Bash) or any terminal with `az` logged into the target subscription.  
2. Clone this repo (or upload the `scripts` folder).
3. Make script executable:
   ```bash
   chmod +x scripts/group1_multitier_deploy.sh
   ```
---

**Detailed Deployment Guide:**  
For full step-by-step instructions, see the [Deployment Steps Documentation](docs/deployment-steps.md).

