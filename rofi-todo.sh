#!/bin/bash

output="$(todo.py cache projects | rofi -dmenu -p 'Todoist: ')"

todo.py add Inbox $output
