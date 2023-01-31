#!/usr/bin/env bash
set -ex
disk="/dev/vda"
swap="4GB"

# curl https://raw.githubusercontent.com/matthewmazzanti/nixos-demo/1-init/setup.sh | sudo bash

# Partition disk
# Layout: 512MB ESP, 4GB swap, rest filled with ext4 root
parted "$disk" -- mklabel gpt
parted "$disk" -- mkpart primary 512MB "-$swap"
parted "$disk" -- mkpart swap linux-swap "-$swap" 100%
parted "$disk" -- mkpart ESP fat32 1MB 512MB
parted "$disk" -- set 3 esp on

# Wait for by-partlabel entries to show up
sleep 1

# Format main drive
partlabel="/dev/disk/by-partlabel"
mkfs.ext4 -L nixos "$partlabel/primary"
# Setup swap
mkswap --label swap "$partlabel/swap"
swapon "$partlabel/swap"
# Format EFI partition
mkfs.fat -F 32 -n boot "$partlabel/ESP"

# Wait for by-label entries to show up
sleep 1

# Mount filesystems
label="/dev/disk/by-label"
mount "$label/nixos" /mnt
mkdir --parents /mnt/boot
mount "$label/boot" /mnt/boot

# Run the installation from git
nix-env --install git
git clone --branch 1-init \
    https://github.com/matthewmazzanti/nixos-demo.git \
    /mnt/etc/nixos
nixos-generate-config \
    --root /mnt \
    --show-hardware-config \
    > /mnt/etc/nixos/hardware-configuration.nix
nixos-install \
    --flake /mnt/etc/nixos#bootstrap \
    --no-root-password
