#!/bin/bash

# Define directories relative to current location
REPO_DIR=$(pwd)  # Current directory where the repo is cloned
FLASK_DIR="/app/site"
HOSTAPD_CONF="/etc/hostapd/hostapd.conf"
DNSMASQ_CONF="/etc/dnsmasq.conf"
FLASK_SERVICE="/etc/systemd/system/flaskapp.service"
WIFI_CHECK_SERVICE="/etc/systemd/system/wifi_check.service"
WIFI_CHECK_SCRIPT="/home/pi/wifi_check.sh"

echo "Updating..."
sudo apt-get update -y
sudo apt-get upgrade -y

echo "Installing dependencies..."
sudo apt-get install python3 -y
sudo apt-get install python3-pip -y
pip install flask

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

# Move the wifi_check service file
echo "Moving Wi-Fi check service file..."
sudo cp "$REPO_DIR/wifi_check.service" "$WIFI_CHECK_SERVICE"

# Move the wifi_check script to /home/pi/
echo "Moving Wi-Fi check script..."
sudo cp "$REPO_DIR/wifi_check.sh" "$WIFI_CHECK_SCRIPT"
sudo chmod +x "$WIFI_CHECK_SCRIPT"

# Enable flaskapp service
echo "Enabling Flask app service..."
sudo systemctl enable flaskapp.service
sudo systemctl start flaskapp.service

# Enable wifi_check service
echo "Enabling Wi-Fi check service..."
sudo systemctl enable wifi_check.service
sudo systemctl start wifi_check.service

# Enable and start the hostapd and dnsmasq services
echo "Starting hostapd and dnsmasq..."
sudo systemctl enable hostapd
sudo systemctl enable dnsmasq
sudo systemctl start hostapd
sudo systemctl start dnsmasq

# Reboot the system to apply all settings
echo "Setup complete! Rebooting now..."
sudo reboot
