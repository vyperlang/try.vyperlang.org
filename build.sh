#!/usr/bin/env bash
# build the docker images for the project

set -Eeuxo pipefail

docker compose build
