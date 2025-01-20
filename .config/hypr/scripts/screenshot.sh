#!/bin/bash

format=png
path="$HOME/Pictures/Screenshots"
filename="Screenshot $(date '+%Y-%m-%d %H%M%S')"

bounds=$(slurp -d)
grim -g "$bounds" -t $format "$path/$filename.$format"
wl-copy < "$path/$filename.$format"
