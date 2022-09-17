#!/usr/bin/env bash

set -e

mkdir -p "$build"
rm -f "$build"/index.css.map

input="$project/sass/index.scss"
output="$build/index.css"

if [[ $env == "production" ]]; then
  sass --style=compressed --no-source-map "$input" "$output"
else
  sass "$input" "$output"
fi
