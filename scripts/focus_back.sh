#!/bin/bash

win=$(yabai -m query --windows --space | jq '[0].id')

yabai -m window $win --focus