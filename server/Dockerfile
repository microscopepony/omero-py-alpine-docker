FROM library/alpine:3.8
MAINTAINER spli@dundee.ac.uk

# Basic utilities and Ice runtime libraries
RUN apk --no-cache add \
        curl \
        db \
        db-c++ \
        bzip2 \
        expat \
        libexecinfo \
        libstdc++ \
        mcpp-libs \
        openjdk8-jre-base \
        openssl \
        python2 \
        py2-pip


# Patch zeroc-ice:
# - musl is missing the non-standard glibc symbols PTHREAD_MUTEX_*_NP

# Ice build
RUN apk --no-cache add --virtual build-dependencies \
        build-base \
        db-dev \
        bzip2-dev \
        expat-dev \
        openssl-dev \
        python2-dev \
        libexecinfo-dev \
        mcpp-dev

COPY ice-3.6.4-alpine-omero.patch /
RUN \
    curl -sfL https://github.com/zeroc-ice/ice/archive/v3.6.4.tar.gz | tar -zxf - && \
    cd ice-3.6.4 && \
    patch -p1 -i ../ice-3.6.4-alpine-omero.patch && \
    cd cpp/src && \
    make && \
    mkdir -p /usr/local/share/man/man1 && \
    make install prefix=/usr/local && \
    cd ../../python && \
    make python && \
    make install prefix=/usr/local && \
    cd ../.. && \
    rm -rf ice-3.6.4 ice-3.6.4-alpine-omero.patch && \
    apk del build-dependencies && \
    icegridnode --version && \
    python -c 'import Ice; print Ice.stringVersion()'

RUN apk --no-cache add \
    # omego requires six \
    py2-six && \
    mkdir -p /opt/omero && \
    pip install omego && \
    cd /opt/omero && \
    omego download server --sym OMERO.server && \
    rm OMERO.server*zip && \
    ln -s /opt/omero/OMERO.server/bin/omero /usr/local/bin/ && \
    adduser -h /opt/omero -D omero && \
    chown -R omero:omero /opt/omero/OMERO.server/

RUN apk --no-cache add \
        py-pillow \
        py-jinja2 \
        py-numpy \
        py-redis \
        py-scipy \
        py-yaml

USER omero
CMD ["omero"]
