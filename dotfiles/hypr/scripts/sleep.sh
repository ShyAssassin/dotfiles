#!/bin/sh

# Miyabi cant hibernate for some reason
if [ "$(hostname)" = "miyabi" ]; then
    echo Miyabi cant hibernate
else
    systemctl hibernate
fi
