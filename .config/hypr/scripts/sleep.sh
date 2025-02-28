#!/bin/sh

# Miyabi cant hibernate for some reason
if [ "$(hostname)" = "miyabi" ]; then
    echo Miyabi cant hibernate
    exit 1
else
    systemctl suspend
fi
