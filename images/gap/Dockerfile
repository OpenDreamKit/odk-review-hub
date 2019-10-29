FROM gapsystem/gap-docker@sha256:77f8f263363b805612ca076a54f1b111238af0e544ab2740c05129f44e6f284e

RUN sudo python3 -mpip install --no-cache \
    jupyterhub==1.0.* \
    jupyterlab==1.1.* \
    nbgitpuller \
    plotly

RUN curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash - \
 && sudo apt-get install -y nodejs \
 && sudo rm -rf /var/lib/apt/lists/*

RUN sudo jupyter labextension install jupyterlab-plotly \
 && sudo jupyter lab clean

ENV HOME=/home/user \
    USER=gap

RUN sudo mkdir $HOME \
 && sudo chown $USER $HOME \
 && sudo usermod -d $HOME $USER

RUN sudo jupyter kernelspec install $GAP_HOME/pkg/JupyterKernel/etc/jupyter
RUN sudo jupyter nbextension install $GAP_HOME/pkg/JupyterKernel/etc/gap-mode && \
    sudo jupyter nbextension enable --sys-prefix gap-mode/main

WORKDIR $HOME

ADD entrypoint /usr/local/bin/entrypoint
ENTRYPOINT ["/usr/local/bin/entrypoint"]
