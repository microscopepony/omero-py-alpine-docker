FROM omero-py-alpine:py
MAINTAINER spli@dundee.ac.uk

USER root
# OMERO.web requirements \
RUN apk --no-cache add \
        py-pillow \
        py-jinja2 \
        py-gunicorn \
        py-numpy \
        py-redis \
        py-yaml && \
    pip install -r /opt/omero/OMERO.py/share/web/requirements-py27.txt && \
    # Serve static files \
    pip install 'whitenoise>4,<5'


# Log to stdout
COPY omeroweb-settings-consolelog.patch /opt/omero/
RUN cd /opt/omero/OMERO.py/lib/python/omeroweb && \
    patch -i /opt/omero/omeroweb-settings-consolelog.patch

# Include limited backwards compatibility with openmicroscopy/omero-web
RUN mkdir /config && \
    mkdir -p /opt/omero/web && \
    ln -s /config /opt/omero/web/config

COPY entrypoint.sh /usr/local/bin/
COPY 00-config.omero /config/

EXPOSE 4080
USER omero
ENTRYPOINT ["entrypoint.sh"]
CMD ["omero", "web", "start", "--foreground"]
