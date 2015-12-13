#!/bin/bash

output="$(task projects | egrep -v '(Project|projects|---)' | \
awk '{print $1}' | sed '/^$/d' | rofi -dmenu -p 'TaskWarrior: ')"

task add project:$output
