#!/usr/bin/env bash
# restart the docker compose stack

# load the environment variables
set -o allexport; source .env; set +o allexport;

set -Eeuxo pipefail

docker compose down
docker compose up --force-recreate --detach
