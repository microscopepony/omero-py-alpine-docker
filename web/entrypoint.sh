#!/bin/sh
set -eux

# https://github.com/openmicroscopy/omero-web-docker/issues/1
rm -f /opt/omero/OMERO.py/var/django.pid

for f in /config/*.omero; do
  if [ -f "$f" ]; then
    omero load "$f"
  fi
done

if [ -n "${OMEROHOST:-}" ]; then
  omero config set omero.web.server_list "[[\"$OMEROHOST\", 4064, \"omero\"]]"
fi

exec "$@"
