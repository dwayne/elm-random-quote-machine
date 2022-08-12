#!/usr/bin/env bash

set -e

caddy file-server --root .build-dev --listen :3000
