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

if [[ "$(uname)" == "Darwin" ]]; then
  exe sudo nix run nix-darwin -- switch $flag --flake .#$host
else
  exe sudo nixos-rebuild switch $flag --flake .#$host
fi
