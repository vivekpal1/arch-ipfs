#!/bin/bash

# ASCII Art
echo "====================================================="
echo "     Arch Linux - IPFS Sync Tool"
echo "====================================================="
echo ""

# Check and Install Kubo (IPFS)
echo "Checking for Kubo (IPFS)..."
if ! command -v ipfs &> /dev/null
then
    echo "Kubo not found. Installing Kubo..."
    sudo pacman -Syu kubo --noconfirm
    echo "Kubo installed."
else
    echo "Kubo is already installed."
fi

# Initialize IPFS
if [ ! -d ~/.ipfs ]; then
    echo "Initializing IPFS..."
    ipfs init
    echo "IPFS initialized."
else
    echo "IPFS is already initialized."
fi

# Define paths and URLs
MIRROR_URL="rsync://geo.mirror.pkgbuild.com/packages"
LOCAL_MIRROR_DIR="/path/to/arch-ipfs"
LOG_FILE="/path/to/log_file.log"

# Sync Function
sync_repo() {
    local repo_name=$1
    echo "Syncing $repo_name..." | tee -a "$LOG_FILE"
    rsync -av --delete-after "$MIRROR_URL/$repo_name/os/x86_64/" "$LOCAL_MIRROR_DIR/$repo_name/" | tee -a "$LOG_FILE"
}

# Add to IPFS Function
add_to_ipfs() {
    local repo_name=$1
    echo "Adding $repo_name to IPFS..." | tee -a "$LOG_FILE"
    ipfs add -r "$LOCAL_MIRROR_DIR/$repo_name/" | tee -a "$LOG_FILE"
}

# Main Execution
echo "Starting sync and IPFS add process..." | tee -a "$LOG_FILE"
sync_repo "core"
add_to_ipfs "core"
sync_repo "extra"
add_to_ipfs "extra"
echo "Process completed!" | tee -a "$LOG_FILE"

