#!/bin/bash

REPO_DIR=$(pwd)
FLASK_DIR="/app/site"
HOSTAPD_CONF="/etc/hostapd/hostapd.conf"
DNSMASQ_CONF="/etc/dnsmasq.conf"
FLASK_SERVICE="/etc/systemd/system/flaskapp.service"

clear

echo "Updating..."
sudo apt-get update -y
sudo apt-get upgrade -y
clear

echo "Installing dependencies..."
sudo apt-get install python3 python3-pip hostapd dnsmasq -y
pip install flask
clear

if [ ! -d "$FLASK_DIR" ]; then
    echo "Creating Flask app directory..."
    sudo mkdir -p "$FLASK_DIR"
fi

echo "Moving Flask app to /app/site/..."
sudo cp -r "$REPO_DIR/site/"* "$FLASK_DIR/"

echo "Moving hostapd config..."
sudo cp "$REPO_DIR/hostapd.conf" "$HOSTAPD_CONF"

echo "Moving dnsmasq config..."
sudo cp "$REPO_DIR/dnsmasq.conf" "$DNSMASQ_CONF"

echo "Moving Flask app service file..."
sudo cp "$REPO_DIR/flaskapp.service" "$FLASK_SERVICE"

clear

echo "Enabling Flask app service..."
sudo systemctl enable flaskapp.service
sudo systemctl start flaskapp.service
clear

echo "Starting hostapd..."
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd
clear

echo "Starting dnsamsq..."
sudo systemctl enable dnsmasq
sudo systemctl start dnsmasq
clear

echo "Setup complete! Rebooting now..."
sudo reboot
