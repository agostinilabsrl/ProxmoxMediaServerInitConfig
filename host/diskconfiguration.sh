#!/bin/bash

# Prompt for user input
read -p "Enter the VM disk path (e.g., /dev/mapper/pve-vm--888--disk--0): " vm_disk_path
read -p "Enter the container ID for Sonarr: " sonarr_id
read -p "Enter the container ID for Radarr: " radarr_id
read -p "Enter the container ID for Plesk: " plesk_id
read -p "Enter the container ID for QbitTorrent: " qbit_id

# Update and upgrade the system
sudo apt-get update && sudo apt-get upgrade -y

# Install essential packages
sudo apt-get install -y curl git vim

# Additional configuration steps can be added below

# Format the VM Disk
sudo mkfs.ext4 $vm_disk_path

# Create a folder named sharedVMDrive in /mnt and mount the disk
sudo mkdir -p /mnt/sharedVMDrive
sudo mount $vm_disk_path /mnt/sharedVMDrive

# Create folders inside the mounted disk
sudo mkdir -p /mnt/sharedVMDrive/downloads
sudo mkdir -p /mnt/sharedVMDrive/tvshows
sudo mkdir -p /mnt/sharedVMDrive/movies

# Give full permissions recursively to the mounted folder
sudo chmod -R 777 /mnt/sharedVMDrive

# Add the mount points to the containers using the provided IDs
sudo pct set $sonarr_id -mp0 /mnt/sharedVMDrive/downloads,mp=/shared/downloads
sudo pct set $radarr_id -mp0 /mnt/sharedVMDrive/downloads,mp=/shared/downloads
sudo pct set $plesk_id -mp0 /mnt/sharedVMDrive/downloads,mp=/shared/downloads
sudo pct set $qbit_id -mp0 /mnt/sharedVMDrive/downloads,mp=/shared/downloads
sudo pct set $sonarr_id -mp1 /mnt/sharedVMDrive/tvshows,mp=/shared/tvshows
sudo pct set $radarr_id -mp1 /mnt/sharedVMDrive/movies,mp=/shared/movies
sudo pct set $plesk_id -mp1 /mnt/sharedVMDrive/tvshows,mp=/shared/tvshows
sudo pct set $plesk_id -mp2 /mnt/sharedVMDrive/movies,mp=/shared/movies
