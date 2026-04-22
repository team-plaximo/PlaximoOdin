#!/usr/bin/env bash
# PlaximoOdin - Systemd Service Installer

SERVICE_FILE="/home/plaximo/PlaximoOdin/scripts/plaximo-odin.service"
TARGET_DIR="/etc/systemd/system"

echo "Installing PlaximoOdin service..."

if [ ! -f "$SERVICE_FILE" ]; then
    echo "Error: Service file $SERVICE_FILE not found."
    exit 1
fi

# Copy service file
sudo cp "$SERVICE_FILE" "$TARGET_DIR/"

# Reload systemd
sudo systemctl daemon-reload

# Enable service
sudo systemctl enable plaximo-odin.service

echo "Service installed and enabled. Starting service..."

# Stop existing manual instances if any
PID_FILE="$HOME/.config/plaximo-odin/server.pid"
if [ -f "$PID_FILE" ]; then
    OLD_PID=$(cat "$PID_FILE")
    if ps -p "$OLD_PID" > /dev/null; then
        echo "Stopping manual llama-server (PID $OLD_PID)..."
        kill "$OLD_PID"
        sleep 2
    fi
fi

# Start service
sudo systemctl start plaximo-odin.service

echo "Done. Check status with: systemctl status plaximo-odin"
