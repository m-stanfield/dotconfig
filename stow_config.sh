#!/bin/bash


# Check if the $XDG_CONFIG_HOME exists, if so use it otherwise use the $HOME/.config directory
if [ -z "$XDG_CONFIG_HOME" ]; then
    target_dir="$HOME/.config"
else
    target_dir="$XDG_CONFIG_HOME"
fi

echo "Stowing to target ${target_dir}"

stow -d config -t ${target_dir} .
