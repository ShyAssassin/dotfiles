#!/bin/sh

exe() {
  if [ $dryrun -eq 1 ]; then
    echo "\$ $@"
    return
  fi
  echo "\$ $@" ; "$@" ;
}

dryrun=0
host=${1:-"$(hostname)"}
flag=${@:2}

if [ "${host:0:1}" == "-" ]; then
  host=$(hostname)
  flag=${@:1}
fi

if [[ $flag == *"--help"* ]]; then
  echo "Usage: switch.sh [HOST] [FLAGS]"
  echo "  HOST: hostname of the target machine"
  echo "  FLAGS:"
  echo "    --deploy: deploy dotfiles"
  echo "    --help: show this help message"
  echo "    --dry-run: show commands without executing"
  echo "    --upgrade: upgrade nix channels and flakes"
  exit 0
fi

if [[ $flag == *"--dry-run"* ]]; then
  flag=${flag/--dry-run/}
  echo "Dry run enabled"
  dryrun=1
fi

if [[ $flag == *"--upgrade"* ]]; then
  exe sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
  exe sudo nix-channel --update
  exe sudo nix flake update
fi

if [[ $flag == *"--deploy"* ]]; then
  flag=${flag/--deploy/}
  exe cp --verbose --link --force .aliasrc ~
  exe cp --verbose --link --force .gitconfig ~
  exe cp --verbose --link --force .gitignore ~
  exe cp --verbose --link --force .gitattributes ~
  exe cp --verbose --recursive --link --force .config/ ~
fi


if [[ "$(uname)" == "Darwin" ]]; then
  exe sudo nix run nix-darwin -- switch $flag --flake .#$host
elif [[ -f /etc/NIXOS ]]; then
  exe sudo nixos-rebuild switch $flag --flake .#$host
else
  echo "Unsupported OS please upgrade packages manually"
fi
