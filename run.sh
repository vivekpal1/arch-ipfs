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

## KEYS
PINATA_API_KEY="your_pinata_api_key"
PINATA_SECRET_API_KEY="your_pinata_secret_api_key"

# Define paths and URLs
MIRROR_URL="rsync://geo.mirror.pkgbuild.com/packages"
LOCAL_MIRROR_DIR="path/to/arch-ipfs"
LOG_FILE="./arch-ipfs.log"

# Sync
sync_repo() {
    local repo_name=$1
    echo "Syncing $repo_name..." | tee -a "$LOG_FILE"
    rsync -av --delete-after "$MIRROR_URL/$repo_name/os/x86_64/" "$LOCAL_MIRROR_DIR/$repo_name/" | tee -a "$LOG_FILE"
}

#Pin to Pinata
pin_to_pinata() {
    local cid=$1
    local name=$2
    echo "Pinning $name to Pinata..."
    curl -X POST "https://api.pinata.cloud/pinning/pinByHash" \
         -H "pinata_api_key: $PINATA_API_KEY" \
         -H "pinata_secret_api_key: $PINATA_SECRET_API_KEY" \
         -H "Content-Type: application/json" \
         -d "{\"hashToPin\":\"$cid\",\"pinataMetadata\":{\"name\":\"$name\"}}" \
         | tee -a "$LOG_FILE"
}

# Add to IPFS
add_to_ipfs() {
    local repo_name=$1
    echo "Adding $repo_name to IPFS..." | tee -a "$LOG_FILE"
    local cid=$(ipfs add -r -Q "$LOCAL_MIRROR_DIR/$repo_name/")
    echo "CID: $cid"
    pin_to_pinata "$cid" "$repo_name"
}

# Main Execution
echo "Starting sync and IPFS add process..." | tee -a "$LOG_FILE"
sync_repo "core"
add_to_ipfs "core"
sync_repo "extra"
add_to_ipfs "extra"
echo "Process completed!" | tee -a "$LOG_FILE"

