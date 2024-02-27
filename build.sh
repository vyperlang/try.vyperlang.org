#!/usr/bin/env bash
# build the docker images for the project

# load the environment variables
set -o allexport; source .env; set +o allexport;

set -Eeuxo pipefail

docker compose build
