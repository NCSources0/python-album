#!/bin/bash

# Define directories relative to current location
REPO_DIR=$(pwd)  # Current directory where the repo is cloned
FLASK_DIR="/app/site"
HOSTAPD_CONF="/etc/hostapd/hostapd.conf"
DNSMASQ_CONF="/etc/dnsmasq.conf"
FLASK_SERVICE="/etc/systemd/system/flaskapp.service"
WIFI_CHECK_SERVICE="/etc/systemd/system/wifi_check.service"
WIFI_CHECK_SCRIPT="/home/pi/wifi_check.sh"

clear

echo "Updating..."
sudo apt-get update -y
clear

echo "Upgrading..."
sudo apt-get upgrade -y
clear

echo "Removing unneeded dependencies..."
sudo apt-get autoremove -y
clear

echo "Installing Python..."
sudo apt-get install python3 -y
clear

echo "Installing pip..."
sudo apt-get install python3-pip -y
clear

echo "Installing Flask from Python..."
pip install flask
clear

echo "Installing Hostapd..."
sudo apt-get install hostapd -y
clear

echo "Installing dnsmasq..."
sudo apt-get install dnsmasq -y
clear

# Create Flask app directory if it doesn't exist
if [ ! -d "$FLASK_DIR" ]; then
    echo "Creating Flask app directory..."
    sudo mkdir -p "$FLASK_DIR"
fi

# Move Flask app to /app/site/
echo "Moving Flask app to /app/site/..."
sudo cp -r "$REPO_DIR/site/"* "$FLASK_DIR/"

# Move the hostapd config
echo "Moving hostapd config..."
sudo cp "$REPO_DIR/hostapd.conf" "$HOSTAPD_CONF"

# Move the dnsmasq config
echo "Moving dnsmasq config..."
sudo cp "$REPO_DIR/dnsmasq.conf" "$DNSMASQ_CONF"

# Move the flaskapp service file
echo "Moving Flask app service file..."
sudo cp "$REPO_DIR/flaskapp.service" "$FLASK_SERVICE"

echo "Enabling Flask app service..."
sudo systemctl enable flaskapp.service
echo "Starting Flask app service..."
sudo systemctl start flaskapp.service
clear

echo "Enabling Hostapd..."
sudo systemctl enable hostapd
echo "Starting Hostapd..."
sudo systemctl start hostapd
clear

echo "Enabling dnsmasq..."
sudo systemctl enable dnsmasq
echo "Starting dnsmasq..."
sudo systemctl start dnsmasq
clear

echo "Setup complete! Rebooting..."
sudo reboot
