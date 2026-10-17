#!/bin/bash

# Configuration
TERMINAL="kitty -e"
# Update everything in one terminal session with exit code check
$TERMINAL bash -c 'yay -Syu'
$TERMINAL bash -c 'flatpak update'

