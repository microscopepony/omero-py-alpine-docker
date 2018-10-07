FROM omero-py-alpine:web
MAINTAINER spli@dundee.ac.uk

USER root
RUN apk --no-cache add \
        # omero-figure \
        py-reportlab \
        py-markdown \
        # omero-mapr \
        py-requests && \
    pip install \
        omero-figure \
        omero-iviewer \
        omero-mapr \
        omero-parade

USER omero
