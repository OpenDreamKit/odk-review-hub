FROM gapsystem/gap-docker-master@sha256:2715268dba1237f22e173931db5d32f45d8d9fd6244e3c1f52548abf4910602e

ADD meataxe-threads.patch /tmp/
RUN cd $GAP_HOME/pkg \
 && wget https://github.com/gap-packages/meataxe64/releases/download/v0.1/meataxe64-0.1.tar.gz \
 && tar -xzf meataxe64*.tar.gz \
 && cd meataxe64* \
 && cat /tmp/meataxe-threads.patch | patch -p1 \
 && ./autogen.sh \
 && ./configure --with-gaproot=$GAP_HOME \
 && make

USER root
RUN apt-get update \
 && apt-get -y install --no-install-recommends \
    vim \
 && rm -rf /var/lib/apt/lists/*

ENV HOME=/home/user \
    USER=gap

USER $USER

RUN sudo python3 -mpip install --no-cache \
    jupyterhub==1.0.* \
    jupyterlab==1.1.* \
    nbgitpuller

RUN sudo mkdir $HOME \
 && sudo chown $USER $HOME \
 && sudo usermod -d $HOME $USER

RUN sudo jupyter kernelspec install $GAP_HOME/pkg/JupyterKernel/etc/jupyter
RUN sudo jupyter nbextension install $GAP_HOME/pkg/JupyterKernel/etc/gap-mode && \
    sudo jupyter nbextension enable --sys-prefix gap-mode/main
WORKDIR $HOME

COPY --chown=$USER jupyter-kernel-gap $GAP_HOME/pkg/JupyterKernel-1.3/bin/jupyter-kernel-gap

ADD entrypoint /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]
