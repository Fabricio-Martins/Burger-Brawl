#!/bin/sh
echo -ne '\033c\033]0;Burger Brawl\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Burger Brawl.x86_64" "$@"
