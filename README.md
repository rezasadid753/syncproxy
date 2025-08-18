# ⚙️ SyncProxy (for Linux)

SyncProxy is a lightweight, zero-dependency bash script that synchronizes your GNOME desktop's network proxy settings to your entire Linux system. It's designed to be a "set-it-and-forget-it" tool that works seamlessly in the background.

> I've previously developed projects like [hiddifycli-launcher](https://github.com/rezasadid753/hiddifycli-launcher/) to bring the simplicity of GUI-based proxy management to the command line. While that project was effective for its specific use case, it became clear that a more generalized solution was needed. GNOME's built-in proxy settings are convenient for web browsing but fail to apply to essential system components like apt or command-line tools. This script, SyncProxy, was developed to address this specific pain point, providing a robust, system-wide proxy solution that dynamically mirrors your GNOME settings, ensuring a consistent network configuration across your desktop environment and terminal. While I used it primarily with [Hiddify](https://github.com/hiddify/hiddify-app), this script is designed to work with any proxy service configured manually in GNOME.

---

## 🛠️ Features

- ### System-wide Proxy
  Automatically sets proxy for apt, apt-get, and all new terminal sessions.
- ### Real-time Monitoring
  An optional background service continuously checks for changes to your GNOME proxy settings and applies them instantly.
- ### Desktop Integration
  Creates a convenient desktop launcher for quick on/off toggling.
- ### Visual Feedback
  The desktop launcher's icon changes in real-time to reflect whether the proxy is active or inactive.
- ### Self-Installing
  The script handles its own installation into a dedicated directory in your home folder.
- ### Clean Uninstallation
  A built-in command removes all created files and configurations.

---

## 📦 Installation

The script is self-installing. It will create a dedicated directory and necessary files in your user's home directory.

1. Download the script:
```bash
curl -o syncproxy.sh https://raw.githubusercontent.com/rezasadid753/proxysync/main/syncproxy.sh
```
2. Make it executable:
```bash
chmod +x syncproxy.sh
```
3. Run the script to install it:
```bash
sudo ./syncproxy.sh
```
The script will handle the rest, including copying itself to ~/syncproxy/, creating the desktop launcher, and setting up the background monitor for real-time synchronization.

---

## 🖱️ Usage

Once installed, you can toggle your proxy settings in two ways:

- ### Using the Desktop Launcher:
  Find and click the "SyncProxy" icon in your applications menu. This will open a terminal, apply the settings, and close automatically.

- ### From the Terminal:
  Simply run the installed script with sudo:
  ```bash
  sudo ~/syncproxy/syncproxy.sh
  ```

- ### Applying Proxy to Current Terminal:
  The changes will automatically apply to all new terminal sessions. To apply the settings to your current terminal without restarting it, manually source the configuration file:
  ```bash
  source /etc/profile.d/gnome-proxy.sh
  ```

---

## 🧹 Uninstallation

To completely remove the script and all associated files, including the desktop launcher, icons, and configuration files:
```bash
sudo ~/syncproxy/syncproxy.sh --uninstall
```

---

## 🧬 How It Works

SyncProxy leverages several standard Linux and GNOME components to operate:

- ### GSettings:
  It uses the gsettings command to securely read the proxy host and port from GNOME's settings (org.gnome.system.proxy.http).

- ### APT Configuration:
  It writes a configuration file to /etc/apt/apt.conf.d/ to set the proxy for the APT package manager.

- ### Shell Environment Variables:
  A script is created at */etc/profile.d/gnome-proxy.sh*. This script exports the necessary http_proxy and https_proxy variables, which are automatically sourced by most shells (like bash and zsh) upon startup.

- ### Desktop Integration:
  It creates a .desktop entry in *~/.local/share/applications/* that links to the script, making it a clickable application in your launcher.

- ### Autostart Monitor:
  It creates a hidden autostart entry in *~/.config/autostart/*. This entry executes the script with the --monitor flag on login, which then starts a background process to continuously watch for changes to your GNOME proxy settings.

---

## 📁 Directory Structure

The script is self-contained and installs all its components into a single directory within your user's home folder:
```
~/syncproxy/
├── syncproxy.sh    # The main script
├── on.svg          # Icon for when the proxy is enabled
└── off.svg         # Icon for when the proxy is disabled
```
