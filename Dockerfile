FROM library/alpine:3.7
MAINTAINER spli@dundee.ac.uk

# Basic utilities and Ice runtime libraries
RUN apk --no-cache add \
        curl \
        db \
        bzip2 \
        expat \
        libstdc++ \
        openssl \
        python2 \
        py2-pip

# Can't use "pip install zeroc-ice==3.6.4" because musl is missing the
# non-standard glibc symbols PTHREAD_MUTEX_*_NP
# http://elias.rhi.hi.is/libc/Mutexes.html

# Ice build
RUN apk --no-cache add --virtual build-dependencies \
        gcc \
        g++ \
        db-dev \
        bzip2-dev \
        expat-dev \
        openssl-dev \
        python2-dev && \
    cd /root && \
    curl -sfL https://files.pythonhosted.org/packages/c4/a8/1ffbaecab4b3a9892529c16a8c6323e37e5467447aa7a92955d68f6c5c45/zeroc-ice-3.6.4.tar.gz | tar -zxf - && \
    cd zeroc-ice-3.6.4 && \
    sed -i.bak s/PTHREAD_MUTEX_ERRORCHECK_NP/PTHREAD_MUTEX_ERRORCHECK/ ./src/ice/cpp/include/IceUtil/Mutex.h && \
    sed -i.bak s/PTHREAD_MUTEX_RECURSIVE_NP/PTHREAD_MUTEX_RECURSIVE/ ./src/ice/cpp/src/IceUtil/RecMutex.cpp && \
    python setup.py build && \
    python setup.py install && \
    cd .. && \
    rm -rf zeroc-ice-3.6.4 && \
    apk del build-dependencies

# OMERO web requirements
RUN apk --no-cache add \
    py-jinja2 \
    py-gunicorn \
    py-pillow \
    py-redis \
    py-six \
    py-yaml

# OMERO web
RUN mkdir -p /opt/omero && \
    pip install omego && \
    cd /opt/omero && \
    omego download py --sym OMERO.py && \
    adduser -h /opt/omero -D omero && \
    pip install -r /opt/omero/OMERO.py/share/web/requirements-py27.txt && \
    ln -s /opt/omero/OMERO.py/bin/omero /usr/local/bin/ && \
    chown -R omero:omero /opt/omero/OMERO.py/

USER omero
CMD ["omero"]
