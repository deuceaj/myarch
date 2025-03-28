#!/usr/bin/env bash

# Define base path for symbolic links
base_target=/media/Epsilon/deuce_dot/

# Define the folders to process
folders=(
    # .steam
    .ssh
    .pcloud
    .fonts
    .vscode
)

# Process each folder
for folder in "${folders[@]}"; do
    # Define paths
    dir_to_check=~/$folder
    symlink_target="$base_target/$folder"
    symlink_name=~/$folder
    
    # Check if the directory exists and delete it
    if [ -d "$dir_to_check" ]; then
        echo "Deleting existing $folder directory..."
        rm -rf "$dir_to_check"
        echo "$folder directory deleted."
    else
        echo "$folder directory does not exist."
    fi

    # Remove existing symbolic link or directory if it exists
    if [ -L "$symlink_name" ] || [ -d "$symlink_name" ]; then
        echo "Removing existing symbolic link or directory for $folder..."
        rm -rf "$symlink_name"
    fi

    # Create the symbolic link
    echo "Creating symbolic link for $folder..."
    ln -s "$symlink_target" "$symlink_name"
    echo "Symbolic link for $folder created."
done

# Check if ckb-next-daemon is enabled, and enable and start if not
if systemctl is-enabled --quiet ckb-next-daemon; then
    echo "ckb-next-daemon is already enabled."
else
    echo "ckb-next-daemon is not enabled. Enabling and starting it..."
    sudo systemctl enable ckb-next-daemon
    sudo systemctl start ckb-next-daemon
    echo "ckb-next-daemon has been enabled and started."
fi

# Copy the bookmarks file
source_bookmarks="/media/Epsilon/deuce_dot/.config/gtk-3.0/bookmarks"
destination_bookmarks="/home/deuce/.config/gtk-3.0/bookmarks"

if [ -f "$source_bookmarks" ]; then
    echo "Copying bookmarks file..."
    cp "$source_bookmarks" "$destination_bookmarks"
    echo "Bookmarks file copied to $destination_bookmarks."
else
    echo "Source bookmarks file $source_bookmarks does not exist."
fi
