FROM jupyter/minimal-notebook@sha256:31c4e330d97bc475666968edda0967c4007345aafae8c876634d66bf5c7ac1bb

RUN conda install -yq \
    autoconf automake \
 && conda clean -pity

USER root
RUN chown $NB_USER /opt
RUN apt-get update \
 && apt-get -y install --no-install-recommends \
    libzmq5-dev \
 && rm -rf /var/lib/apt/lists/*

USER $NB_USER
WORKDIR /opt

ENV GAPROOT=/opt/gap

RUN git clone --depth 1 https://github.com/gap-system/gap gap \
 && cd gap \
 && ./autogen.sh \
 && ./configure --enable-hpcgap \
 && make -j4 \
 && make bootstrap-pkg-full \
 && cd pkg \
 && ../bin/BuildPackages.sh

# install the gap kernel
ENV PATH=$GAPROOT/bin:$PATH
ENV JUPYTER_GAP_EXECUTABLE ${GAPROOT}/bin/gap.sh

RUN jupyter kernelspec install \
    --sys-prefix \
    --name gap-4 \
    $GAPROOT/pkg/JupyterKernel*/etc/jupyter/ \
 && ln -s $GAPROOT/pkg/JupyterKernel*/bin/jupyter-kernel-gap $CONDA_DIR/bin/jupyter-kernel-gap


# install nbgitpuller
RUN pip install --no-cache nbgitpuller

# setup the home dir
USER root
ENV HOME=/home/user
RUN mkdir $HOME \
 && chown $NB_USER $HOME \
 && usermod -d $HOME $NB_USER
USER $NB_USER

WORKDIR $HOME
