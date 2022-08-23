#!/usr/bin/env bash

set -e

port="${1:-3000}"

caddy file-server --root .build --listen :"$port"
