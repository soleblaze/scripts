#!/bin/bash

output="$(doing last | rofi -dmenu -p 'doing: ')"

doing done
doing now "$output"
