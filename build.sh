#!/usr/bin/env bash

# build the docker images
set -Eeuxo pipefail

docker compose build
