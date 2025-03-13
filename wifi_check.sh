#!/bin/bash

# Configured SSID for the hotspot and for scanning networks
HOTSPOT_SSID="Albumeer Network"

# Function to start the hotspot (open network)
start_hotspot() {
    echo "Starting Wi-Fi hotspot..."
    sudo systemctl start hostapd
    sudo systemctl start dnsmasq
}

# Function to stop the hotspot
stop_hotspot() {
    echo "Stopping Wi-Fi hotspot..."
    sudo systemctl stop hostapd
    sudo systemctl stop dnsmasq
}

# Scan for available Wi-Fi networks
echo "Scanning for Wi-Fi networks..."
SCAN_RESULTS=$(sudo iwlist wlan0 scan | grep ESSID)

# Check if the configured SSID is found in the scan results
if echo "$SCAN_RESULTS" | grep -q "\"$HOTSPOT_SSID\""; then
    echo "Network with SSID $HOTSPOT_SSID found. Attempting to connect..."

    # Create the wpa_supplicant configuration file for the matching network (no password)
    sudo tee /etc/wpa_supplicant/wpa_supplicant.conf > /dev/null <<EOL
    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    update_config=1
    country=US

    network={
        ssid="$HOTSPOT_SSID"
        key_mgmt=NONE
    }
    EOL

    # Stop the hotspot if it's running
    stop_hotspot

    # Restart networking services to connect to the Wi-Fi network
    sudo wpa_cli -i wlan0 reconfigure
    sudo systemctl restart dhcpcd

    # Check if the connection was successful
    sleep 10
    if sudo wpa_cli status | grep -q "wpa_state=COMPLETED"; then
        echo "Successfully connected to $HOTSPOT_SSID!"
    else
        echo "Failed to connect. Starting hotspot..."
        start_hotspot
    fi
else
    echo "No matching network found. Starting hotspot..."
    start_hotspot
fi