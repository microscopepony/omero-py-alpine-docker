#!/bin/sh
set -eux

# https://github.com/openmicroscopy/omero-web-docker/issues/1
rm -f /opt/omero/OMERO.py/var/django.pid

for f in /config/*.omero; do
  if [ -f "$f" ]; then
    omero load "$f"
  fi
done

exec "$@"
