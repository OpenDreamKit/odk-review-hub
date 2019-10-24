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

RUN sudo python3 -mpip install --no-cache \
    jupyterhub==1.0.* \
    jupyterlab==1.1.* \
    nbgitpuller

ENV HOME=/home/user \
    USER=gap

RUN sudo mkdir $HOME \
 && sudo chown $USER $HOME \
 && sudo usermod -d $HOME $USER

WORKDIR $HOME
