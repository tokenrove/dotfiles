#!/bin/sh

set -eu

# Install packages
sudo apt -y install --no-install-recommends $(cat debian-packages.*)

# Keyboard defaults
sudo cp default/keyboard /etc/default/keyboard
sudo etckeeper commit 'update keyboard layout'
