#!/bin/sh
exe() { echo "\$ $@" ; "$@" ; }

host=${1:-$(hostname)}
flag=${@:2}

if [ "${host:0:1}" == "-" ]; then
  flag=${@:1}
  host=$(hostname)
fi

if [[ $flag == *"--upgrade"* ]]; then
  exe sudo nix flake update
fi

exe sudo nixos-rebuild switch $flag --flake .#$host
