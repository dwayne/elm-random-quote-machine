#!/usr/bin/env bash

set -e

build_dir=.build
static_dir=static

tmp_dir=$(mktemp -d)

echo "[HTML]"
root_dir=elm-random-quote-machine
sed "s/{{ROOT}}/\/$root_dir/" $static_dir/index.html > $tmp_dir/index.html

echo "[CSS]"
cp $static_dir/index.css $tmp_dir/

echo "[ELM]"
elm make src/Main.elm --optimize --output=$tmp_dir/app.js

# Update the build directory
rm -rf $build_dir
mkdir $build_dir
mv $tmp_dir $build_dir/$root_dir

echo "[DONE]"
