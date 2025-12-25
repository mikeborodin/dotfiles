#!/bin/bash

# Get the directory of this script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

launchctl setenv XDG_CONFIG_HOME ~/.config
launchctl setenv WEZTERM_CONFIG_FILE "$DIR/wezterm/wezterm_config.lua"