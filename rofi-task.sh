#!/bin/bash

output="$(todo.py projects | rofi -dmenu -p 'Todoist: ')"

todo.py add $output
