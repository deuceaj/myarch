#!/bin/bash

echo -ne "
-------------------------------------------------------------------------
██╗   ██╗██████╗ ██████╗  █████╗ ████████╗███████╗    
██║   ██║██╔══██╗██╔══██╗██╔══██╗╚══██╔══╝██╔════╝    
██║   ██║██████╔╝██║  ██║███████║   ██║   █████╗      
██║   ██║██╔═══╝ ██║  ██║██╔══██║   ██║   ██╔══╝      
╚██████╔╝██║     ██████╔╝██║  ██║   ██║   ███████╗    
 ╚═════╝ ╚═╝     ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝    
                                                      
██████╗  ██████╗ ██╗     ██╗  ██╗██╗████████╗         
██╔══██╗██╔═══██╗██║     ██║ ██╔╝██║╚══██╔══╝         
██████╔╝██║   ██║██║     █████╔╝ ██║   ██║            
██╔═══╝ ██║   ██║██║     ██╔═██╗ ██║   ██║            
██║     ╚██████╔╝███████╗██║  ██╗██║   ██║            
╚═╝      ╚═════╝ ╚══════╝╚═╝  ╚═╝╚═╝   ╚═╝            
                                                                                                          
-------------------------------------------------------------------------
"



# Error log file
error_log="/tmp/polkit_script_errors.log"
> $error_log  # Clear previous errors

# Function to log errors
log_error() {
    echo "[ERROR] $1" | tee -a $error_log
}

# Create the file /etc/polkit-1/rules.d/49-nopasswd_global.rules
polkit_file="/etc/polkit-1/rules.d/49-nopasswd_global.rules"
if sudo touch $polkit_file; then
    echo "File $polkit_file created successfully"
else
    log_error "Failed to create $polkit_file"
fi

# Set the appropriate permissions for the file
if sudo chmod 644 $polkit_file; then
    echo "Permissions set for $polkit_file"
else
    log_error "Failed to set permissions for $polkit_file"
fi

# Insert the required text into the file
if sudo bash -c 'cat << EOF > /etc/polkit-1/rules.d/49-nopasswd_global.rules
/* Allow members of the wheel group to execute any actions
 * without password authentication, similar to "sudo NOPASSWD:"
 */
polkit.addRule(function(action, subject) {
    if (subject.isInGroup("deuce")) {
        return polkit.Result.YES;
    }
});
EOF'; then
    echo "Text successfully added to $polkit_file"
else
    log_error "Failed to add text to $polkit_file"
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
