#!/bin/sh

host=${1:-}
sudo nixos-rebuild switch --flake .#$host
