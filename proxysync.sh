#!/bin/bash

# --- GLOBAL CONFIGURATION ---
# The target directory and script name for self-installation.
TARGET_DIR_NAME="syncproxy"
TARGET_SCRIPT_NAME="syncproxy.sh"

# Get the original user's home directory for file placement.
# This is crucial for when the script is run with sudo.
if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
    USER_NAME=$SUDO_USER
else
    USER_HOME=$HOME
    USER_NAME=$(whoami)
fi

TARGET_PATH="$USER_HOME/$TARGET_DIR_NAME/$TARGET_SCRIPT_NAME"

# Configuration file paths for system-wide proxy settings.
APT_PROXY_FILE="/etc/apt/apt.conf.d/99gnome-proxy.conf"
PROFILE_PROXY_FILE="/etc/profile.d/gnome-proxy.sh"

# Paths to the user's icons and desktop entry.
ON_ICON_PATH="$USER_HOME/$TARGET_DIR_NAME/on.svg"
OFF_ICON_PATH="$USER_HOME/$TARGET_DIR_NAME/off.svg"
DESKTOP_ENTRY_PATH="$USER_HOME/.local/share/applications/syncproxy.desktop"
AUTOSTART_ENTRY_PATH="$USER_HOME/.config/autostart/syncproxy.desktop"

# --- HELPER FUNCTIONS ---

# Function to write the SVG icon files.
write_svg_icons() {
    # Check if the on.svg file exists. If not, create both.
    if [ ! -f "$ON_ICON_PATH" ]; then
        echo "Creating on.svg icon..."
        cat > "$ON_ICON_PATH" << 'EOF'
<svg width="500" height="500" viewBox="0 0 500 500" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0 130C0 58.203 58.203 0 130 0H370C441.797 0 500 58.203 500 130V289H0V130Z" fill="#007D51"/>
<path d="M395 60C406.046 60 415 68.9543 415 80V141C415 152.046 406.046 161 395 161H268V188.077C276.925 191.916 284.084 199.075 287.923 208H350C358.284 208 365 214.716 365 223C365 231.284 358.284 238 350 238H287.923C282.105 251.527 268.659 261 253 261C237.341 261 223.895 251.527 218.077 238H156C147.716 238 141 231.284 141 223C141 214.716 147.716 208 156 208H218.077C221.916 199.075 229.075 191.916 238 188.077V161H111C99.9543 161 91 152.046 91 141V80C91 68.9543 99.9543 60 111 60H395ZM310 115C302.82 115 297 120.82 297 128C297 135.18 302.82 141 310 141C317.18 141 323 135.18 323 128C323 120.82 317.18 115 310 115ZM346 115C338.82 115 333 120.82 333 128C333 135.18 338.82 141 346 141C353.18 141 359 135.18 359 128C359 120.82 353.18 115 346 115ZM382 115C374.82 115 369 120.82 369 128C369 135.18 374.82 141 382 141C389.18 141 395 135.18 395 128C395 120.82 389.18 115 382 115Z" fill="white"/>
<path d="M0 289H500V370C500 441.797 441.797 500 370 500H130C58.203 500 0 441.797 0 370V289Z" fill="#383838"/>
<path d="M242.358 392.166V396.95C242.358 404.623 241.318 411.511 239.238 417.612C237.158 423.714 234.223 428.914 230.433 433.213C226.642 437.465 222.112 440.724 216.843 442.989C211.619 445.254 205.818 446.387 199.439 446.387C193.107 446.387 187.306 445.254 182.036 442.989C176.813 440.724 172.283 437.465 168.446 433.213C164.61 428.914 161.628 423.714 159.502 417.612C157.422 411.511 156.382 404.623 156.382 396.95V392.166C156.382 384.447 157.422 377.559 159.502 371.504C161.582 365.402 164.517 360.202 168.308 355.903C172.144 351.604 176.674 348.323 181.897 346.058C187.167 343.793 192.968 342.66 199.301 342.66C205.68 342.66 211.481 343.793 216.704 346.058C221.974 348.323 226.504 351.604 230.294 355.903C234.131 360.202 237.089 365.402 239.169 371.504C241.295 377.559 242.358 384.447 242.358 392.166ZM221.35 396.95V392.027C221.35 386.665 220.864 381.951 219.894 377.883C218.923 373.815 217.49 370.395 215.595 367.621C213.7 364.848 211.388 362.768 208.661 361.381C205.934 359.948 202.814 359.231 199.301 359.231C195.788 359.231 192.668 359.948 189.94 361.381C187.259 362.768 184.971 364.848 183.076 367.621C181.227 370.395 179.817 373.815 178.847 377.883C177.876 381.951 177.391 386.665 177.391 392.027V396.95C177.391 402.266 177.876 406.981 178.847 411.095C179.817 415.162 181.25 418.606 183.146 421.426C185.041 424.199 187.352 426.302 190.079 427.735C192.806 429.168 195.926 429.885 199.439 429.885C202.952 429.885 206.073 429.168 208.8 427.735C211.527 426.302 213.815 424.199 215.664 421.426C217.513 418.606 218.923 415.162 219.894 411.095C220.864 406.981 221.35 402.266 221.35 396.95ZM339.498 344.047V445H318.697L278.136 377.328V445H257.335V344.047H278.136L318.767 411.788V344.047H339.498Z" fill="white"/>
</svg>
EOF
        echo "Creating off.svg icon..."
        cat > "$OFF_ICON_PATH" << 'EOF'
<svg width="500" height="500" viewBox="0 0 500 500" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M0 130C0 58.203 58.203 0 130 0H370C441.797 0 500 58.203 500 130V289H0V130Z" fill="#BB0707"/>
<path d="M395 60C406.046 60 415 68.9543 415 80V141C415 152.046 406.046 161 395 161H268V188.077C276.925 191.916 284.084 199.075 287.923 208H350C358.284 208 365 214.716 365 223C365 231.284 358.284 238 350 238H287.923C282.105 251.527 268.659 261 253 261C237.341 261 223.895 251.527 218.077 238H156C147.716 238 141 231.284 141 223C141 214.716 147.716 208 156 208H218.077C221.916 199.075 229.075 191.916 238 188.077V161H111C99.9543 161 91 152.046 91 141V80C91 68.9543 99.9543 60 111 60H395ZM310 115C302.82 115 297 120.82 297 128C297 135.18 302.82 141 310 141C317.18 141 323 135.18 323 128C323 120.82 317.18 115 310 115ZM346 115C338.82 115 333 120.82 333 128C333 135.18 338.82 141 346 141C353.18 141 359 135.18 359 128C359 120.82 353.18 115 346 115ZM382 115C374.82 115 369 120.82 369 128C369 135.18 374.82 141 382 141C389.18 141 395 135.18 395 128C395 120.82 389.18 115 382 115Z" fill="white"/>
<path d="M0 289H500V370C500 441.797 441.797 500 370 500H130C58.203 500 0 441.797 0 370V289Z" fill="#383838"/>
<path d="M214.555 392.166V396.95C214.555 404.623 213.515 411.511 211.435 417.612C209.354 423.714 206.419 428.914 202.629 433.213C198.839 437.465 194.309 440.724 189.039 442.989C183.816 445.254 178.015 446.387 171.636 446.387C165.303 446.387 159.502 445.254 154.232 442.989C149.009 440.724 144.479 437.465 140.643 433.213C136.806 428.914 133.825 423.714 131.698 417.612C129.618 411.511 128.578 404.623 128.578 396.95V392.166C128.578 384.447 129.618 377.559 131.698 371.504C133.778 365.402 136.714 360.202 140.504 355.903C144.34 351.604 148.87 348.323 154.094 346.058C159.363 343.793 165.164 342.66 171.497 342.66C177.876 342.66 183.677 343.793 188.9 346.058C194.17 348.323 198.7 351.604 202.49 355.903C206.327 360.202 209.285 365.402 211.365 371.504C213.492 377.559 214.555 384.447 214.555 392.166ZM193.546 396.95V392.027C193.546 386.665 193.061 381.951 192.09 377.883C191.119 373.815 189.686 370.395 187.791 367.621C185.896 364.848 183.585 362.768 180.857 361.381C178.13 359.948 175.01 359.231 171.497 359.231C167.984 359.231 164.864 359.948 162.137 361.381C159.456 362.768 157.168 364.848 155.272 367.621C153.424 370.395 152.014 373.815 151.043 377.883C150.072 381.951 149.587 386.665 149.587 392.027V396.95C149.587 402.266 150.072 406.981 151.043 411.095C152.014 415.162 153.447 418.606 155.342 421.426C157.237 424.199 159.548 426.302 162.275 427.735C165.003 429.168 168.123 429.885 171.636 429.885C175.149 429.885 178.269 429.168 180.996 427.735C183.723 426.302 186.011 424.199 187.86 421.426C189.709 418.606 191.119 415.162 192.09 411.095C193.061 406.981 193.546 402.266 193.546 396.95ZM250.332 344.047V445H229.531V344.047H250.332ZM290.547 387.174V403.398H244.646V387.174H290.547ZM295.4 344.047V360.341H244.646V344.047H295.4ZM328.266 344.047V445H307.465V344.047H328.266ZM368.48 387.174V403.398H322.58V387.174H368.48ZM373.334 344.047V360.341H322.58V344.047H373.334Z" fill="white"/>
</svg>
EOF
    fi
    # Change ownership to the user, since the script may be run with sudo
    chown "$USER_NAME:$USER_NAME" "$ON_ICON_PATH"
    chown "$USER_NAME:$USER_NAME" "$OFF_ICON_PATH"
}

# Function to create or update the desktop entry for launching the script.
create_desktop_entry() {
    echo "Creating desktop entry for SyncProxy..."
    mkdir -p "$USER_HOME/.local/share/applications"
    cat > "$DESKTOP_ENTRY_PATH" << EOF
[Desktop Entry]
Name=SyncProxy
Comment=Toggle SyncProxy
Exec=gnome-terminal -- bash -c "echo 'You may be prompted for your password to run this script with administrative privileges.'; sudo $TARGET_PATH; read -n 1 -s -r -p 'Press any key to close this terminal...'"
Icon=$OFF_ICON_PATH
Terminal=true
Type=Application
EOF
    # Set the correct permissions and ownership
    chmod +x "$DESKTOP_ENTRY_PATH"
    chown "$USER_NAME:$USER_NAME" "$DESKTOP_ENTRY_PATH"
    echo "Desktop entry created at $DESKTOP_ENTRY_PATH"
}

# Function to create or update the autostart entry for monitoring.
create_autostart_entry() {
    echo "Creating autostart entry for continuous proxy monitoring..."
    mkdir -p "$USER_HOME/.config/autostart"
    cat > "$AUTOSTART_ENTRY_PATH" << EOF
[Desktop Entry]
Name=SyncProxy Monitor
Comment=Continuously monitors and syncs proxy settings.
Exec=sudo $TARGET_PATH --monitor
Icon=$ON_ICON_PATH
Terminal=false
Hidden=false
NoDisplay=true
Type=Application
X-GNOME-Autostart-enabled=true
EOF
    # Set the correct permissions and ownership
    chmod +x "$AUTOSTART_ENTRY_PATH"
    chown "$USER_NAME:$USER_NAME" "$AUTOSTART_ENTRY_PATH"
    echo "Autostart entry created at $AUTOSTART_ENTRY_PATH"
}

# --- PROXY CONTROL FUNCTIONS ---

# Function to set the proxy (turn it on)
set_proxy() {
    echo "--- Setting system-wide proxy from GNOME settings ---"
    
    PROXY_HOST=$(sudo -u "$SUDO_USER" gsettings get org.gnome.system.proxy.http host | tr -d "'")
    PROXY_PORT=$(sudo -u "$SUDO_USER" gsettings get org.gnome.system.proxy.http port)

    if [ -z "$PROXY_HOST" ] || [ "$PROXY_HOST" == "''" ] || [ "$PROXY_PORT" -eq 0 ]; then
        echo "GNOME proxy is not set or not in 'Manual' mode. Nothing to do."
        echo "Please configure it in Settings > Network > Network Proxy."
        exit 0
    fi

    echo "Found GNOME Proxy: http://$PROXY_HOST:$PROXY_PORT"

    # Set up proxy for APT
    echo "Configuring apt proxy at $APT_PROXY_FILE..."
    echo "Acquire::http::Proxy \"http://$PROXY_HOST:$PROXY_PORT/\";" > "$APT_PROXY_FILE"
    echo "Acquire::https::Proxy \"http://$PROXY_HOST:$PROXY_PORT/\";" >> "$APT_PROXY_FILE"
    
    # Set up proxy for system-wide shell sessions
    echo "Configuring shell environment variables at $PROFILE_PROXY_FILE..."
    echo "# This file is automatically generated by syncproxy.sh" > "$PROFILE_PROXY_FILE"
    echo "export http_proxy=\"http://$PROXY_HOST:$PROXY_PORT/\"" >> "$PROFILE_PROXY_FILE"
    echo "export https_proxy=\"http://$PROXY_HOST:$PROXY_PORT/\"" >> "$PROFILE_PROXY_FILE"
    echo "export HTTP_PROXY=\"http://$PROXY_HOST:$PROXY_PORT/\"" >> "$PROFILE_PROXY_FILE"
    echo "export HTTPS_PROXY=\"http://$PROXY_HOST:$PROXY_PORT/\"" >> "$PROFILE_PROXY_FILE"
    echo "export no_proxy=\"localhost,127.0.0.1,localaddress\"" >> "$PROFILE_PROXY_FILE"

    echo "--- Applying settings to current session ---"
    # This part should be handled by the user's shell after the script exits
    echo "Proxy has been set. To apply to your current terminal session, run:"
    echo "source $PROFILE_PROXY_FILE"
    
    # Update the desktop icon
    sudo -u "$SUDO_USER" sed -i "s|Icon=.*|Icon=$ON_ICON_PATH|" "$DESKTOP_ENTRY_PATH"

    echo "Proxy has been turned ON. The icon has been changed."
}

# Function to turn off the proxy
unset_proxy() {
    echo "--- Disabling system-wide proxy configuration ---"
    
    # Remove the apt configuration file
    if [ -f "$APT_PROXY_FILE" ]; then
        echo "Removing apt proxy file: $APT_PROXY_FILE"
        rm -f "$APT_PROXY_FILE"
    fi

    # Remove the shell environment variable script
    if [ -f "$PROFILE_PROXY_FILE" ]; then
        echo "Removing shell environment file: $PROFILE_PROXY_FILE"
        rm -f "$PROFILE_PROXY_FILE"
    fi

    # Update the desktop icon
    sudo -u "$SUDO_USER" sed -i "s|Icon=.*|Icon=$OFF_ICON_PATH|" "$DESKTOP_ENTRY_PATH"
    
    echo "Proxy has been turned OFF. The icon has been changed."
    echo "To clear settings from other terminals, a new terminal session is required or they must be manually cleared."
}

# Function to remove all created files and directories.
uninstall() {
    echo "--- Uninstalling SyncProxy ---"
    # Remove system-wide files
    rm -f "$APT_PROXY_FILE" "$PROFILE_PROXY_FILE"
    # Remove user-specific files
    rm -f "$DESKTOP_ENTRY_PATH" "$AUTOSTART_ENTRY_PATH"
    # Remove the main directory
    rm -rf "$USER_HOME/$TARGET_DIR_NAME"
    echo "Uninstallation complete. All files have been removed."
    exit 0
}

# --- CONTINUOUS MONITORING ---

# Function to run as a daemon and monitor proxy changes.
monitor_proxy() {
    echo "Starting continuous proxy monitor... (PID: $$)"
    echo "This process will run in the background."
    
    # We need to run this as the user who started the script, not root.
    if [ "$EUID" -eq 0 ]; then
        echo "Error: Monitor must be run as a user, not root."
        exit 1
    fi
    
    LAST_HOST=$(gsettings get org.gnome.system.proxy.http host | tr -d "'")
    LAST_PORT=$(gsettings get org.gnome.system.proxy.http port)

    while true; do
        CURRENT_HOST=$(gsettings get org.gnome.system.proxy.http host | tr -d "'")
        CURRENT_PORT=$(gsettings get org.gnome.system.proxy.http port)

        # Check if the settings have changed
        if [ "$CURRENT_HOST" != "$LAST_HOST" ] || [ "$CURRENT_PORT" != "$LAST_PORT" ]; then
            echo "Proxy settings changed. Re-applying..."
            # Re-execute the main script with sudo to apply the changes.
            sudo "$TARGET_PATH"
            LAST_HOST="$CURRENT_HOST"
            LAST_PORT="$CURRENT_PORT"
        fi
        
        sleep 5
    done
}

# --- MAIN SCRIPT LOGIC ---

# Step 0: Ensure script is running with sudo.
if [[ $EUID -ne 0 ]]; then
    echo "This script must be run with sudo to apply changes system-wide."
    echo "Re-launching with sudo. Please enter your password."
    sudo "$0" "$@"
    exit
fi

# Step 1: Handle the uninstall flag first.
if [ "$1" == "--uninstall" ]; then
    uninstall
fi

# Step 2: Handle different modes of operation.
case "$1" in
    --monitor)
        # Check for --monitor flag to start the continuous check.
        # This will be run automatically on login via the autostart entry.
        monitor_proxy
        ;;
    *)
        # Default behavior: Self-install if needed, then toggle.
        # Fixed: Use readlink to get the absolute path of the script for a correct check.
        if [[ "$(readlink -f "$0")" != "$TARGET_PATH" ]]; then
            echo "SyncProxy script is not installed in the correct location."
            echo "Performing self-installation..."

            mkdir -p "$USER_HOME/$TARGET_DIR_NAME"
            
            # Copy the script to the target directory with the correct name.
            cp "$0" "$TARGET_PATH"
            
            # Make the new file executable.
            chmod +x "$TARGET_PATH"
            
            # Create the necessary user files.
            write_svg_icons
            create_desktop_entry
            create_autostart_entry
            
            echo "Installation complete. Please re-run the script from its new location or use the desktop shortcut."
            echo "New location: $TARGET_PATH"
            exit 0
        fi

        # If it's already installed, toggle the proxy on/off.
        if [ -f "$PROFILE_PROXY_FILE" ]; then
            unset_proxy
        else
            set_proxy
        fi
        ;;
esac
