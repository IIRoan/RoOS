#!/bin/bash

set -ouex pipefail

### Install packages

# Packages can be installed from any enabled yum repo on the image.
# RPMfusion repos are available by default in ublue main images
# List of rpmfusion packages can be found here:
# https://mirrors.rpmfusion.org/mirrorlist?path=free/fedora/updates/39/x86_64/repoview/index.html&protocol=https&redirect=1

# Development tools
dnf5 install -y android-tools
dnf5 install -y neovim
dnf5 install -y git
dnf5 install -y gcc
dnf5 install -y make

# Add Microsoft repository and install VSCode
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo
dnf5 install -y code

# Container and virtualization tools
dnf5 install -y docker
dnf5 install -y podman
dnf5 install -y distrobox
dnf5 install -y toolbox
dnf5 install -y virt-manager
dnf5 install -y qemu-kvm
dnf5 install -y libvirt

# Terminal and shell tools
dnf5 install -y zsh
dnf5 install -y zsh-autosuggestions
dnf5 install -y yakuake

# Security and network tools
dnf5 install -y nmap
dnf5 install -y wireshark
dnf5 install -y hashcat

# Existing packages
dnf5 install -y tmux 
dnf5 install -y btop 

# Use a COPR Example:
#
# dnf5 -y copr enable ublue-os/staging
# dnf5 -y install package
# Disable COPRs so they don't end up enabled on the final image:
# dnf5 -y copr disable ublue-os/staging

#### Enable System Unit Files

systemctl enable podman.socket
systemctl enable docker.socket
systemctl enable libvirtd.service

#### Add RoOS just recipes

echo "import \"/usr/share/roos/just/roos.just\"" >> /usr/share/ublue-os/justfile

#### Setup RoOS branding

# Create GSettings override for GNOME branding
mkdir -p /usr/share/glib-2.0/schemas
cat > /usr/share/glib-2.0/schemas/99-roos-branding.gschema.override << 'EOF'
[org.gnome.desktop.interface]
icon-theme='RoOS'

[org.gnome.shell]
app-picker-view=1

[org.gnome.desktop.background]
picture-uri='file:///usr/share/pixmaps/roos-logo.png'
picture-uri-dark='file:///usr/share/pixmaps/roos-logo.png'
EOF

# Create custom icon theme that includes RoOS branding
mkdir -p /usr/share/icons/RoOS/scalable/apps
mkdir -p /usr/share/icons/RoOS/256x256/apps
mkdir -p /usr/share/icons/RoOS/128x128/apps
mkdir -p /usr/share/icons/RoOS/48x48/apps
mkdir -p /usr/share/icons/RoOS/32x32/apps
mkdir -p /usr/share/icons/RoOS/16x16/apps

# Create icon theme index
cat > /usr/share/icons/RoOS/index.theme << 'EOF'
[Icon Theme]
Name=RoOS
Comment=RoOS Icon Theme
Inherits=Adwaita
Directories=16x16/apps,32x32/apps,48x48/apps,128x128/apps,256x256/apps,scalable/apps

[16x16/apps]
Size=16
Context=Applications
Type=Fixed

[32x32/apps]
Size=32
Context=Applications
Type=Fixed

[48x48/apps]
Size=48
Context=Applications
Type=Fixed

[128x128/apps]
Size=128
Context=Applications
Type=Fixed

[256x256/apps]
Size=256
Context=Applications
Type=Fixed

[scalable/apps]
Size=256
Context=Applications
Type=Scalable
MinSize=16
MaxSize=512
EOF

# Copy RoOS logos to custom icon theme
cp /usr/share/icons/hicolor/16x16/apps/roos-logo.png /usr/share/icons/RoOS/16x16/apps/
cp /usr/share/icons/hicolor/32x32/apps/roos-logo.png /usr/share/icons/RoOS/32x32/apps/
cp /usr/share/icons/hicolor/48x48/apps/roos-logo.png /usr/share/icons/RoOS/48x48/apps/
cp /usr/share/icons/hicolor/128x128/apps/roos-logo.png /usr/share/icons/RoOS/128x128/apps/
cp /usr/share/icons/hicolor/256x256/apps/roos-logo.png /usr/share/icons/RoOS/256x256/apps/
cp /usr/share/icons/hicolor/scalable/apps/roos-logo.svg /usr/share/icons/RoOS/scalable/apps/

# Also replace common system logo references
cp /usr/share/pixmaps/roos-logo.svg /usr/share/pixmaps/gnome-logo-text.svg
cp /usr/share/pixmaps/roos-logo.svg /usr/share/pixmaps/gnome-foot.svg
cp /usr/share/pixmaps/roos-logo.png /usr/share/pixmaps/system-logo-white.png

# Compile GSettings schemas
glib-compile-schemas /usr/share/glib-2.0/schemas/

# Update icon caches
gtk-update-icon-cache /usr/share/icons/hicolor/ || true
gtk-update-icon-cache /usr/share/icons/RoOS/ || true
