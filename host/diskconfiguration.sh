#!/bin/bash

# Set default values
default_vm_disk_path="/dev/mapper/pve-vm--888--disk--0"
default_sonarr_id="101"
default_radarr_id="102"
default_plex_id="103"
default_qbit_id="104"

# Prompt for user input with default values
read -p "Enter the VM disk path (default: $default_vm_disk_path): " vm_disk_path
vm_disk_path=${vm_disk_path:-$default_vm_disk_path}

read -p "Enter the container ID for Sonarr (default: $default_sonarr_id): " sonarr_id
sonarr_id=${sonarr_id:-$default_sonarr_id}

read -p "Enter the container ID for Radarr (default: $default_radarr_id): " radarr_id
radarr_id=${radarr_id:-$default_radarr_id}

read -p "Enter the container ID for Plex (default: $default_plex_id): " plex_id 
plex_id=${plex_id:-$default_plex_id}

read -p "Enter the container ID for QbitTorrent (default: $default_qbit_id): " qbit_id
qbit_id=${qbit_id:-$default_qbit_id}

# Additional configuration steps can be added below

# Format the VM Disk
mkfs.ext4 $vm_disk_path

# Create a folder named sharedVMDrive in /mnt and mount the disk
mkdir -p /mnt/sharedVMDrive
mount $vm_disk_path /mnt/sharedVMDrive

# Create folders inside the mounted disk
mkdir -p /mnt/sharedVMDrive/downloads
mkdir -p /mnt/sharedVMDrive/tvshows
mkdir -p /mnt/sharedVMDrive/movies

# Give full permissions recursively to the mounted folder
chmod -R 777 /mnt/sharedVMDrive

# Add the mount points to the containers using the provided IDs
pct set $sonarr_id -mp0 /mnt/sharedVMDrive/downloads,mp=/shared/downloads
pct set $radarr_id -mp0 /mnt/sharedVMDrive/downloads,mp=/shared/downloads
pct set $plex_id -mp0 /mnt/sharedVMDrive/downloads,mp=/shared/downloads 
pct set $qbit_id -mp0 /mnt/sharedVMDrive/downloads,mp=/shared/downloads
pct set $sonarr_id -mp1 /mnt/sharedVMDrive/tvshows,mp=/shared/tvshows
