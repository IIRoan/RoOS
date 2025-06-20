# Install all RoOS curated apps
roos-install: roos-install-flatpaks roos-install-brews

# Install only Flatpaks
roos-install-flatpaks:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Installing Flatpaks..."
  xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/roan/roos/main/repo_files/flatpaks) flatpak --system -y install
  echo "Flatpaks installation complete."

# Install only Homebrews
roos-install-brews:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Installing Homebrews..."
  xargs -a <(curl --retry 3 -sL https://raw.githubusercontent.com/roan/roos/main/repo_files/brews) brew install
  echo "Homebrews installation complete."

# Setup RoOS recommended settings for VSCode
roos-setup-editors:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Setting up VSCode configuration..."
  config_dir="${HOME}/.config/Code/User"
  mkdir -p "$config_dir"
  cp -f "/etc/skel/.config/Code/User/settings.json" "$config_dir/settings.json"
  echo "VSCode setup complete."

# Setup Ghostty terminal configuration
roos-setup-ghostty:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Setting up Ghostty configuration..."
  config_dir="${HOME}/.config/ghostty"
  mkdir -p "$config_dir"
  cp -f "/etc/skel/.config/ghostty/config" "$config_dir/config"
  echo "Ghostty setup complete."

# Setup shell configurations (zsh, bash)
roos-setup-shells:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Setting up shell configurations..."

  # Setup Zsh configuration
  echo "Setting up Zsh configuration..."
  cp -f "/etc/skel/.zshrc" "${HOME}/.zshrc"
  cp -f "/etc/skel/.zprofile" "${HOME}/.zprofile"
  echo "Zsh configuration complete."

  # Setup Bash configuration
  echo "Setting up Bash configuration..."
  cp -f "/etc/skel/.bashrc" "${HOME}/.bashrc"
  cp -f "/etc/skel/.bash_profile" "${HOME}/.bash_profile"
  cp -f "/etc/skel/.bash_logout" "${HOME}/.bash_logout"
  echo "Bash configuration complete."

  echo "Shell configurations setup complete."

# Restart Bluetooth to fix issues
roos-fix-bt:
  #!/usr/bin/env bash
  set -euo pipefail
  trap '[[ $BASH_COMMAND != echo* ]] && echo "+ $BASH_COMMAND"' DEBUG

  echo "Fixing Bluetooth..."
  sudo rfkill unblock all
  sudo rmmod btusb
  sudo modprobe btusb
  echo "Bluetooth fix complete."

# Clean up old packages and Docker/Podman images and volumes
roos-clean:
  #!/usr/bin/env bash
  set -euo pipefail

  echo "Cleaning up system..."
  docker system prune -af
  podman system prune -af
  flatpak uninstall --unused
  rpm-ostree cleanup -bm
  sudo docker system prune -af
  sudo podman system prune -af
  echo "System cleanup complete."