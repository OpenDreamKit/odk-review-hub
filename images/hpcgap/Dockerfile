FROM jupyter/minimal-notebook@sha256:31c4e330d97bc475666968edda0967c4007345aafae8c876634d66bf5c7ac1bb

RUN conda install -yq \
    autoconf automake \
 && conda clean -pity

USER root
RUN chown $NB_USER /opt
RUN apt-get update \
 && apt-get -y install --no-install-recommends \
    libzmq5-dev \
    bison \
    flex \
    vim \
 && rm -rf /var/lib/apt/lists/*
USER $NB_USER

WORKDIR /opt

ENV GAPROOT=/opt/gap
ENV GAP_VERSION=5d7dad621856a93ec86345c8b557ce6e35236d36

RUN mkdir $GAPROOT \
 && cd $GAPROOT \
 && git init \
 && git remote add origin https://github.com/gap-system/gap \
 && git fetch --depth 1 origin \
    $GAP_VERSION \
 && git checkout FETCH_HEAD \
 && ./autogen.sh \
 && ./configure --enable-hpcgap \
 && make -j4 \
 && make bootstrap-pkg-full \
 && cd pkg \
 && cd ZeroMQ* \
 && wget -O - https://github.com/gap-packages/ZeroMQInterface/pull/26.patch | patch -p1 \
 && cd .. \
 && ../bin/BuildPackages.sh

# install the gap kernel
ENV PATH=$GAPROOT/bin:$PATH

RUN jupyter kernelspec install \
    --sys-prefix \
    --name gap-4 \
    $GAPROOT/pkg/JupyterKernel*/etc/jupyter/ \
 && ln -s $GAPROOT/pkg/JupyterKernel*/bin/jupyter-kernel-gap $CONDA_DIR/bin/jupyter-kernel-gap

# install nbgitpuller
RUN pip install --no-cache nbgitpuller

# configure gap kernel
ENV JUPYTER_GAP_EXECUTABLE "${GAPROOT}/bin/gap.sh -r -A -S --single-thread"

# setup the home dir
USER root
ENV HOME=/home/user
RUN mkdir $HOME \
 && chown $NB_USER $HOME \
 && usermod -d $HOME $NB_USER
USER $NB_USER

WORKDIR $HOME
