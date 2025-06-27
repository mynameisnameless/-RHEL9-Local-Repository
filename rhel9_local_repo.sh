#!/bin/bash

# Variables
DEVICE="/dev/sr0"
MOUNT_POINT="/mnt/disc"
REPO_FILE="/etc/yum.repos.d/rhel9.repo"

# Ensure the script is run as root
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run as root."
    exit 1
fi

# Check if the device exists
if [[ ! -b "$DEVICE" ]]; then
    echo "Error: Device $DEVICE not found."
    exit 1
fi

# Mount the device if not already mounted
if ! mountpoint -q "$MOUNT_POINT"; then
    mkdir -p "$MOUNT_POINT"
    mount "$DEVICE" "$MOUNT_POINT"
    if [[ $? -ne 0 ]]; then
        echo "Error: Failed to mount $DEVICE."
        exit 1
    fi
    echo "Mounted $DEVICE to $MOUNT_POINT."
else
    echo "$DEVICE is already mounted on $MOUNT_POINT."
fi

# Create the local repository file
cat > "$REPO_FILE" <<EOF
[BaseOS]
name=BaseOS Packages Red Hat Enterprise Linux 9
metadata_expire=-1
gpgcheck=1
enabled=1
baseurl=file://$MOUNT_POINT/BaseOS/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release

[AppStream]
name=AppStream Packages Red Hat Enterprise Linux 9
metadata_expire=-1
gpgcheck=1
enabled=1
baseurl=file://$MOUNT_POINT/AppStream/
gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-redhat-release
EOF

echo "Local repository configured in $REPO_FILE."

# Clean and update repository cache
yum clean all
yum makecache

echo "Local repository is ready for use."

