#!/bin/bash

if [ $# -eq 0 ]; then
    echo "No arguments provided"
    exit 1
fi
rm -rf "${PWD}/./artifacts"
docker run --rm \
    -v "${PWD}/${1}":/package:ro \
    -v "${PWD}/artifacts":/artifacts \
    -it $(docker build -q .)
