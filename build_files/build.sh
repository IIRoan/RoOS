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
dnf5 install -y ghostty
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
