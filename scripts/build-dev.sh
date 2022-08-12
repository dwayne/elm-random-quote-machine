#!/usr/bin/env bash

set -e

BUILD_DIR=.build-dev
STATIC_DIR=static

echo "[CLEAN]"
rm -rf $BUILD_DIR

echo "[COPY]"
cp -r $STATIC_DIR $BUILD_DIR

echo "[BUILD]"
elm make src/Main.elm --debug --output=$BUILD_DIR/app.js

echo "[DONE]"
