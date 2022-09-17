#!/usr/bin/env bash

set -e

root="${1:-}"

mkdir -p "$build"
sed "s|{{ROOT}}|$root|" "$project/html/index.html" > "$build/index.html"
