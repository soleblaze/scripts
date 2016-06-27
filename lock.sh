#!/usr/bin/env bash
tmpbg='/tmp/screen.png'

maim "$tmpbg"
convert "$tmpbg" -scale 10% -scale 1000% "$tmpbg"
i3lock -i "$tmpbg"
rm "$tmpbg"