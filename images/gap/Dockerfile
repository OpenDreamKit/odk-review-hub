FROM gapsystem/gap-docker@sha256:77f8f263363b805612ca076a54f1b111238af0e544ab2740c05129f44e6f284e

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
