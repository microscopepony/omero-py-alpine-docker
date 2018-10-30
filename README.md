# Minimal OMERO.py images based on Alpine Linux

OMERO.py and OMERO.web Docker images built on Alpine Linux.

- [`py`](py): OMERO.py
- [`web`](web): OMERO.web, patched to log to stdout
- [`webapps`](webapps): OMERO.web with released web apps (disabled by default). See [`webapps/example-webapps.omero`](webapps/example-webapps.omero) for an example configuration.


## Development

The purpose of these images is to provide a small Docker image for running OMERO.py and OMERO.web.
For any complex requirements use the official [omero-web-docker](https://github.com/openmicroscopy/omero-web-docker) image instead.
