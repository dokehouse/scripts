# dokehouse

A collection of scripts and utilities for my homelab and servers.

## Usage

## Hardware used

### Cloud Servers (Joe's Datacenter, KCMO)

- `dokecloud-1`
  - Purpose: Primary Coolify instance (Debian 12.8)
  - Specs: 2 vCPUs, 2GB RAM

- `dokecloud-2`
  - Purpose: Docker host managed by dokecloud-1 (Debian 12.8)
  - Specs: 4 vCPUs, 8GB RAM

### Home Servers

- `dokebox`
  - Purpose: Proxmox VE host for lightweight services (Home Assistant, Caddy)
  - Specs: Intel N100 (2C/2T), 4GB RAM

- `dokestation`
  - Purpose: Proxmox VE workstation host (Windows 11 VM, heavy workloads)
  - Specs: Intel N100 (2C/2T), 4GB RAM
