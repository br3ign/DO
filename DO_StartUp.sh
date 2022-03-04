#!/bin/bash
#
# Digital Ocean user setup script 
# uncle_beppy

# This script assumes you are the root user
# This script also assumes you are running on Ubuntu

cur=$(whoami)

if [ "$cur" != root ]; then
	echo "Currently logged in as $cur."
	echo "You are not the root user. Exiting..."
	exit 0
fi

# Prompt user for desired username
read -p 'Desired username: ' varUser

# Execute adduser
adduser $varUser

# Add user to sudoers
echo "Adding user to sudo group"
usermod -aG sudo $varUser

read -p "Grant $varUser ssh access with current key? (Y/N) " grantSSH

if [ "$grantSSH" = "Y" ] || [ "$grantedSSH" = "y" ]; then
	$(rsync --archive --chown=$varUser:$varUser ~/.ssh /home/$varUser)
fi

# Basic iptables config
read -p "Setup iptables? (Y/N) " configIPTBL

if [ "$configIPTBL" = "N" ] || ["$configIPTBL" = "n"]; then
	echo "$varUser successfully created."
	echo "Please disconnect and try connecting with the new user account via ssh."
	exit 0
elif [ "$configIPTBL" = "Y" ] || [ "$configIPTBL" = "y" ]; then
	echo "Allowing OpenSSH..."
	ufw allow OpenSSH
	echo "Enabling ufw"
	ufw enable
	ufw status
	
	echo "$varUser successfully created."
	echo "Please disconnect and try connecting with the new user account via ssh."
	echo "Remember to secure your SSH access. Use fail2ban, etc."
	exit 0
fi
