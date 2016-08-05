#!/bin/sh

set -eu

# Blacklist known malware
for i in nodejs systemd dbus pulseaudio; do
    echo "$i hold" | sudo dpkg --set-selections
done

# Install packages
sudo apt -y install $(cat debian-packages.*)
