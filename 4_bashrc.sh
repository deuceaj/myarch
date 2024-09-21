#!/bin/bash

# Error log file
error_log="/tmp/bashrc_replace_errors.log"
> $error_log  # Clear any previous error log

# Function to log errors
log_error() {
    echo "[ERROR] $1" | tee -a $error_log
}

# Function to replace .bashrc in the home directory with the one from the current folder
replace_bashrc() {
    current_folder=$(pwd)
    if [ -f "$current_folder/.bashrc" ]; then
        echo "
-------------------------------------------------------------------------
Replacing .bashrc in home directory with the one from the current folder
-------------------------------------------------------------------------
"
        if ! cp "$current_folder/.bashrc" ~/.bashrc; then
            log_error "Failed to replace .bashrc in home directory"
        else
            echo ".bashrc has been successfully replaced."
        fi
    else
        log_error ".bashrc file not found in the current folder"
    fi
}

# Check if .bashrc exists in the home directory
if [ -f ~/.bashrc ]; then
    echo "
-------------------------------------------------------------------------
.bashrc already exists in your home directory.
-------------------------------------------------------------------------
"
    read -p "Do you want to replace it with the .bashrc from the current folder? (y/n): " choice
    case "$choice" in 
        y|Y )
            replace_bashrc
            ;;
        n|N )
            echo "Keeping the existing .bashrc file."
            ;;
        * )
            echo "Invalid input. Exiting without replacing .bashrc."
            ;;
    esac
else
    echo "
-------------------------------------------------------------------------
No .bashrc found in home directory. Proceeding with replacement.
-------------------------------------------------------------------------
"
    replace_bashrc
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
