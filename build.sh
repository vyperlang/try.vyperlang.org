#!/usr/bin/env bash
# build the docker images for the project

set -Eeuxo pipefail

# load the environment variables
set -o allexport; source .env; set +o allexport;

docker compose build
