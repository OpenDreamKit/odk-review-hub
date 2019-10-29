FROM registry.gitlab.com/sagemath/sage/sagemath:9.0.beta0-py3
ENV USER=sage

# Configure environment
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

# Install conda as jovyan and check the md5 sum provided on the download site
ENV MINICONDA_VERSION=4.7.10 \
    CONDA_VERSION=4.7.12

USER root
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    build-essential \
    bzip2 \
    ca-certificates \
    fonts-liberation \
    git \
    locales \
    make \
    wget \
 && rm -rf /var/lib/apt/lists/*

 RUN cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "1c945f2b3335c7b2b15130b1b2dc5cf4 *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda install --quiet --yes conda && \
    $CONDA_DIR/bin/conda update --all --quiet --yes && \
    conda list python | grep '^python ' | tr -s ' ' | cut -d '.' -f 1,2 | sed 's/$/.*/' >> $CONDA_DIR/conda-meta/pinned && \
    conda clean --all -f -y && \
    rm -rf $HOME/.cache && \
    rm -rf $HOME/.conda && \
    chown -R $USER $CONDA_DIR

ENV HOME=/home/user
RUN mkdir $HOME \
 && chown $USER $HOME \
 && usermod -d $HOME $USER

WORKDIR $HOME

USER $USER

ENV PATH=$CONDA_DIR/envs/notebook/bin:$PATH

# strip qt, pyqt because they are unused and huge
ADD environment.yml /tmp/environment.yml
RUN conda env create -n notebook -f /tmp/environment.yml \
 && conda remove -n notebook --force --yes qt pyqt \
 && conda clean -pity \
 && jupyter lab clean

RUN python3 -m pip install nbgitpuller

RUN sage -pip install pypersist
RUN sage -pip install git+https://github.com/nthiery/sage-gap-semantic-interface.git
RUN sage -pip install git+https://github.com/sagemath/sage-combinat-widgets.git
RUN sage -pip install git+https://github.com/sagemath/sage-explorer.git

ENV SAGE_ROOT=/home/sage/sage
ENV JUPYTER_DATA_DIR=$SAGE_ROOT/local/share/jupyter

# install jupyterlab extensions
RUN cp -v \
    $SAGE_ROOT/local/share/jupyter/lab/extensions/* \
    $CONDA_DIR/envs/notebook/share/jupyter/lab/extensions \
# sage-combinat-widgets breaks jupyterlab
 && rm /opt/conda/envs/notebook/share/jupyter/lab/extensions/sage-combinat-widgets* \
 && jupyter labextension install --no-build @jupyter-widgets/jupyterlab-manager \
 && jupyter labextension install --no-build k3d \
 && jupyter lab build \
 && jupyter lab clean

USER root
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    libgl1-mesa-dev \
 && rm -rf /var/lib/apt/lists/*
USER $NB_USER

# enable sage-combinat-widgets in notebook environment
RUN jupyter nbextension enable --sys-prefix sage-combinat-widgets/extension

# remove duplicate sage Python kernel
RUN rm -rvf $JUPYTER_DATA_DIR/kernels/python3

# rename gap kernel to match gap's own docker image (with version)
RUN mv $JUPYTER_DATA_DIR/kernels/gap $JUPYTER_DATA_DIR/kernels/gap-4

# patch sage kernels to invoke sage to launch
ADD patch-kernels.py /tmp/patch-kernels.py
RUN python3 /tmp/patch-kernels.py

# make sure conda is fully activated at launch
ADD activate-conda.sh /etc/profile.d/activate-conda.sh
# make sure sage is activated at launch (disabled, that's done at kernel launch)
# ADD sage-env.sh /etc/profile.d/00-sage-env.sh
ADD entrypoint /usr/local/bin/entrypoint

ENTRYPOINT ["/usr/local/bin/entrypoint"]
