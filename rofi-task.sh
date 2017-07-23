#!/bin/bash

output="$(rofi -dmenu -p 'Todoist: ')"

todo.py add Inbox $output
