#!/bin/sh

format=png
path="$HOME/Pictures/Screenshots"
filename="Screenshot $(date '+%Y-%m-%d %H%M%S')"

hyprpicker -rz &
sleep 0.2 # wait on hyprpicker
bounds=$(slurp -d)
grim -g "$bounds" -t $format "$path/$filename.$format"
wl-copy < "$path/$filename.$format"
killall hyprpicker
