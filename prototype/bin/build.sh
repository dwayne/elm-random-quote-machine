#!/usr/bin/env bash

project="$PROJECT/prototype"
sass="$project/node_modules/.bin/sass"

"$sass" "$project/styles/index.scss" "$project/index.css"
