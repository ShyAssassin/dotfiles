#!/bin/sh

# Miyabi cant hibernate for some reason
if [ "$(hostname)" = "miyabi" ]; then
    systemctl suspend
    echo Miyabi cant hibernate
else
    systemctl hibernate
fi
