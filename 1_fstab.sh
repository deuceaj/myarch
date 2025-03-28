#!/bin/bash

# Error log file
error_log="/tmp/script_errors.log"
> $error_log  # Clear previous errors

# Function to log errors
log_error() {
    echo "[ERROR] $1" | tee -a $error_log
}

# Ask for username credential
read -p "Enter your username credential: " username

# Ask for password credential
read -s -p "Enter your password credential: " password
echo ""  # Move to a new line after entering the password

# Create .smbcredentials file in the ~/.local folder with both username and password
if echo -e "username=$username\npassword=$password" > ~/.local/.smbcredentials; then
    echo "smbcredential file created"
else
    log_error "Failed to create .smbcredentials file"
fi

# Ensure the /media directory exists
if [ ! -d "/media" ]; then
    if ! sudo mkdir /media; then
        log_error "Failed to create /media directory"
    fi
fi

# Create media directories
if sudo mkdir /media/Delta /media/Epsilon /media/Gamma /media/Theta; then
    echo "Media Folders have been created"
else
    log_error "Failed to create media directories"
fi

# Change ownership of the media directories
if ! sudo chown -R deuce:deuce /media /media/Delta /media/Epsilon /media/Gamma /media/Theta; then
    log_error "Failed to change ownership of media directories"
fi

# Install cifs-utils
if ! sudo pacman -Sy --noconfirm cifs-utils; then
    log_error "Failed to install cifs-utils"
fi

# Create a backup of /etc/fstab
if sudo cp /etc/fstab /etc/fstab.bak; then
    echo "Backup of /etc/fstab created"
else
    log_error "Failed to create backup of /etc/fstab"
fi

# Append the desired text to /etc/fstab
if ! sudo bash -c 'cat << EOF >> /etc/fstab

#Mount Hard Drives
    UUID=b1121d57-4180-4ad1-af4f-158af3b18883   /media/Epsilon   btrfs   nofail             0 0


#Mount Network Drives
    //192.168.2.11/Delta/                       /media/Delta     cifs    vers=2.0,credentials=/home/deuce/.local/.smbcredentials,iocharset=utf8,gid=1000,uid=1000,file_mode=0777,dir_mode=0777   0 0
    //192.168.2.11/Theta                        /media/Theta/    cifs    vers=2.0,credentials=/home/deuce/.local/.smbcredentials,iocharset=utf8,gid=1000,uid=1000,file_mode=0777,dir_mode=0777   0 0

EOF'; then
    echo "Text appended to /etc/fstab"
else
    log_error "Failed to append text to /etc/fstab"
fi

# Display the contents of /etc/fstab
cat /etc/fstab

# Pause before mounting
sleep 2

# Mount all filesystems
if ! sudo mount -a; then
    log_error "Failed to mount filesystems"
fi

# Check if there were any errors and display them
if [ -s $error_log ]; then
    echo "Script completed with errors:"
    cat $error_log
else
    echo "Script completed successfully without any errors."
fi

# Clean up error log file
rm $error_log
