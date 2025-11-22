#!/usr/bin/env sh
set -eu

URL_HEALTH=${URL_HEALTH:-http://api.localhost/healthz}
URL_DB=${URL_DB:-http://api.localhost/db}
URL_CACHE=${URL_CACHE:-http://api.localhost/cache}
TRIES=${TRIES:-10}
SLEEP=${SLEEP:-2}

try_url() {
  url=$1
  i=1
  while [ $i -le $TRIES ]; do
    if curl -fsS "$url" >/dev/null 2>&1; then
      echo "OK: $url"
      return 0
    fi
    echo "WAIT($i/$TRIES): $url"
    i=$((i+1))
    sleep "$SLEEP"
  done
  echo "FAIL: $url"
  return 1
}

echo "Checking $URL_HEALTH"
try_url "$URL_HEALTH"

echo "Checking $URL_DB"
try_url "$URL_DB"

echo "Checking $URL_CACHE"
try_url "$URL_CACHE"

echo "All checks passed"

