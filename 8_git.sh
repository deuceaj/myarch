#!/bin/bash

# Prompt for user email and name
read -p "Enter your Git email: " user_email
read -p "Enter your Git username: " user_name

# Update global Git configuration
git config --global user.email "$user_email"
git config --global user.name "$user_name"

echo "Git configuration updated:"
echo "Email: $user_email"
echo "Username: $user_name"
