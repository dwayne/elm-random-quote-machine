#!/usr/bin/env bash

set -e

build_dir=.build-dev
static_dir=static

echo "[CLEAN]"
rm -rf $build_dir

echo "[COPY]"
cp -r $static_dir $build_dir

echo "[BUILD]"
elm make src/Main.elm --debug --output=$build_dir/app.js

echo "[DONE]"
