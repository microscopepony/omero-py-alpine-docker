#!/bin/sh
set -eux

for f in /config/*.omero; do
  if [ -f "$f" ]; then
    omero load "$f"
  fi
done

exec "$@"
