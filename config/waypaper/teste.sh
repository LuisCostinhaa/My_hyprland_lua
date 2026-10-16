#!/bin/bash

WALLPAPER=$(awww query 2>/dev/null | sed -n 's/.*image: \(.*\)$/\1/p')
wal -i $WALLPAPER -e -n -s -t
matugen image $WALLPAPER

alacritty -e bash -c "matugen --show-colors -t scheme-fidelity image \"$WALLPAPER\"; read"
