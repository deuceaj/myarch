#!/bin/bash

# Error log file
error_log="/tmp/virt_manager_errors.log"
> $error_log  # Clear any previous error log

# Function to log errors
log_error() {
    echo "[ERROR] $1" | tee -a $error_log
}

echo "
-------------------------------------------------------------------------
Enable and Start Libvirt
-------------------------------------------------------------------------
"
if ! sudo systemctl enable --now libvirtd.service; then
    log_error "Failed to enable and start libvirtd.service"
fi

echo "
-------------------------------------------------------------------------
Set default network, autostart, and check status
-------------------------------------------------------------------------
"
if ! sudo virsh net-start default; then
    log_error "Failed to start default network"
fi

if ! sudo virsh net-autostart default; then
    log_error "Failed to set autostart for default network"
fi

echo "
-------------------------------------------------------------------------
Add user to libvirt group
-------------------------------------------------------------------------
"
if ! sudo usermod -a -G libvirt $(whoami); then
    log_error "Failed to add user to libvirt group"
fi

echo "
-------------------------------------------------------------------------
Restart session to apply group changes
-------------------------------------------------------------------------
"
if ! newgrp libvirt; then
    log_error "Failed to restart session with libvirt group"
fi

echo "
-------------------------------------------------------------------------
Restarting Libvirt service
-------------------------------------------------------------------------
"
if ! sudo systemctl restart libvirtd.service; then
    log_error "Failed to restart libvirtd.service"
fi

# Check if there were any errors and display them
if [ -s $error_log ]; then
    echo "
-------------------------------------------------------------------------
Script completed with errors:
-------------------------------------------------------------------------
"
    cat $error_log
else
    echo "
-------------------------------------------------------------------------
Script completed successfully without any errors.
-------------------------------------------------------------------------
"
fi

# Clean up error log file
rm $error_log
