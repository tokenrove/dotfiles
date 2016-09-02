#!/bin/sh

set -eu

# Update to sid


# Blacklist known malware
for i in nodejs systemd dbus pulseaudio; do
    echo "$i hold" | sudo dpkg --set-selections
done

# Keyboard defaults
sudo sed -i 's/^XKBOPTIONS=""$/XKBOPTIONS="ctrl:nocaps,compose:ralt"/' /etc/default/keyboard

# Install packages
sudo apt -y install $(cat debian-packages.*)
