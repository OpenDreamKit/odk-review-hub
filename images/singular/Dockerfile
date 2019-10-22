FROM jupyter/minimal-notebook@sha256:31c4e330d97bc475666968edda0967c4007345aafae8c876634d66bf5c7ac1bb
USER root
RUN apt-get -y update \
 && apt-get -y install --no-install-recommends \
    autoconf \
    autogen \
    build-essential \
    bzip2 \
    # clang \
    # cmake \
    curl \
    g++ \
    gcc \
    git \
    libgmp-dev \
    libgmp10 \
    libgmpxx4ldbl \
    libmpfr-dev \
    libtool \
    m4 \
    make \
    # nano \
    # ninja-build \
    patch \
    pkg-config \
    sudo \
    unzip \
    # vim \
    wget \
    # xsltproc \
 && rm -rf /var/lib/apt/lists/*

RUN mkdir /src \
 && chmod 777 /src \
 && mkdir /opt/singular \
 && fix-permissions /opt/singular

ENV PATH=/opt/singular/bin:$PATH \
    PREFIX=/opt/singular

USER $NB_USER
WORKDIR /src
RUN git clone https://github.com/wbhart/flint2 \
 && cd flint2 \
 && git checkout c585238 \
 && ./configure --prefix=$PREFIX \
 && make \
 && make install \
 && cd .. \
 && rm -rf flint2

ENV CFLAGS="-I$CONDA_DIR/include"\
    LDFLAGS="-Wl,-rpath,$CONDA_DIR/lib"
RUN git clone https://github.com/Singular/Sources \
 && cd Sources \
 && git checkout f03a589 \
 && ./autogen.sh \
 && ./configure --disable-omalloc --with-flint=$PREFIX --prefix=$PREFIX \
 && make \
 && make install \
 && cd .. \
 && rm -rf Sources

