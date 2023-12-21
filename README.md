# Arch Linux - IPFS Sync Tool 🚀

This tool automates the process of checking for, installing, and running Kubo (the Arch Linux IPFS implementation), setting up IPFS, and syncing the `core` and `extra` repositories of Arch Linux to your local machine and IPFS.

## Installation 🛠️


```bash
git clone https://github.com/vivekpal1/arch-ipfs.git
cd arch-ipfs
chmod +x run.sh
```

## Usage 🖥️

To use the tool, run the script from the command line:

```bash
./run.sh
```

The script will:
1. Check for Kubo (IPFS) and install it if it's not present.
2. Initialize IPFS if it hasn't been initialized yet.
3. Sync the `core` and `extra` repositories.
4. Add the repositories to IPFS.

Logs are generated and can be found at `./arch-ipfs.log`.

> This is for arch x86_64 only