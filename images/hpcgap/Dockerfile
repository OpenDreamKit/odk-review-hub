FROM jupyter/minimal-notebook@sha256:31c4e330d97bc475666968edda0967c4007345aafae8c876634d66bf5c7ac1bb

RUN conda install -yq \
    autoconf automake \
 && conda clean -pity

USER root
RUN chown $NB_USER /opt
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
 && ../bin/BuildPackages.sh \
 ;  cd ZeroMQ* \
 && ./configure --with-zmq=$CONDA_DIR \
 && make

ENV PATH=$GAP_DIR/bin:$PATH

RUN pip install --no-cache nbgitpuller

USER root
ENV HOME=/home/user
RUN mkdir $HOME \
 && chown $NB_USER $HOME \
 && usermod -d $HOME $NB_USER
USER $NB_USER

WORKDIR $HOME
