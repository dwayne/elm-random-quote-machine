#!/usr/bin/env bash

caddy file-server --browse --root "$PROTOTYPE" --listen :"${1:-8000}"
