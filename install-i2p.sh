#!/usr/bin/env bash
set -e
ROUTER_URL="http://127.0.0.1:7657"
PROXY_HOST="127.0.0.1"
PROXY_PORT="4444"
USER_NAME=$(logname)
DESKTOP_PATH="/home/$USER_NAME/Desktop"
INSTRUCTIONS_FILE="$DESKTOP_PATH/I2P-Start-Here.txt"

check_root() {
    if [[ $EUID -ne 0 ]]; then
        echo "This script must be run as root (try: sudo $0)"
        exit 1
    fi
}

add_ppa() {
    echo "[1/5] Adding I2P PPA..."
    apt-add-repository -y ppa:i2p-maintainers/i2p
}

update_packages() {
    echo "[2/5] Updating package list..."
    apt-get update -y
}

install_i2p() {
    echo "[3/5] Installing I2P..."
    apt-get install -y i2p
}

write_instructions() {
    echo "[4/5] Writing desktop instructions..."
    mkdir -p "$DESKTOP_PATH"
    cat <<EOF > "$INSTRUCTIONS_FILE"
I2P has been installed on your system 🎉

To start I2P manually, open a terminal and run:
    i2prouter start

To stop it:
    i2prouter stop

To have I2P start automatically at boot, run:
    sudo dpkg-reconfigure i2p

Router console:
    $ROUTER_URL

For Firefox setup:
1. Open Preferences → Network Settings → Settings…
2. Choose "Manual proxy configuration"
3. HTTP Proxy: $PROXY_HOST   Port: $PROXY_PORT
4. Check "Use this proxy server for all protocols"
5. Save.

You may need to reboot for all services to initialize cleanly.
EOF
    chown "$USER_NAME":"$USER_NAME" "$INSTRUCTIONS_FILE"
}
echo "=== I2P Installer ==="
check_root
add_ppa
update_packages
install_i2p
write_instructions

echo
echo "✅ Installation complete. Desktop instructions file: $INSTRUCTIONS_FILE"
echo "Reboot recommended for clean initialization."
