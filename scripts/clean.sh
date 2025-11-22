#!/usr/bin/env sh
set -eu

COMPOSE=${COMPOSE:-docker compose}
PROJECT=${PROJECT:-}

confirm() {
  printf "This will stop containers and remove volumes/networks for this project. Continue? [y/N] "
  read -r ans || exit 1
  [ "$ans" = "y" ] || [ "$ans" = "Y" ] || { echo "Aborted"; exit 1; }
}

confirm

if [ -n "$PROJECT" ]; then
  export COMPOSE_PROJECT_NAME="$PROJECT"
fi

$COMPOSE down -v --remove-orphans || true

echo "Pruned compose resources."

