#!/usr/bin/env bash

set -e

echo "[PREPARE]"
build_dir=.build-development
config_dir=scripts/development/config
static_dir=static
tmp_dir=$(mktemp -d)

echo "[COPY:CSS]"
cp $static_dir/index.css $tmp_dir/

echo "[BUILD:HTML]"
npx mustache $config_dir/index.html.json $static_dir/index.html.mustache $tmp_dir/index.html

echo "[BUILD:ELM]"
elm make src/Main.elm --debug --output=$tmp_dir/app.js

# Move everything into the build directory.
rm -rf $build_dir
cp -r $tmp_dir $build_dir
rm -rf $tmp_dir

echo "[DONE]"
