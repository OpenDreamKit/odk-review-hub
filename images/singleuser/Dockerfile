FROM registry.gitlab.com/sagemath/sage/sagemath:9.0.beta0-py3
ENV USER=sage
# Configure environment
ENV CONDA_DIR=/opt/conda
ENV PATH=$CONDA_DIR/bin:$PATH

# Install conda as jovyan and check the md5 sum provided on the download site
ENV MINICONDA_VERSION=4.7.10 \
    CONDA_VERSION=4.7.10

USER root
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    wget \
    bzip2 \
    ca-certificates \
    locales \
    fonts-liberation \
    run-one \
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

USER $USER

ADD environment.yml /tmp/environment.yml
RUN conda env create -n notebook -f /tmp/environment.yml \
 && conda run -n notebook jupyter lab build \
 && conda run -n notebook jupyter lab clean \
 && conda clean -pity

RUN rm -rvf $HOME/sage/local/share/jupyter/kernels/python3
RUN mkdir -p $HOME/.local/share && \
    ln -s $HOME/sage/local/share/jupyter $HOME/.local/share/jupyter

ENV SAGE_ROOT=$HOME/sage

# patch sage kernels to invoke sage to launch
ADD patch-kernels.py /tmp/patch-kernels.py
RUN python3 /tmp/patch-kernels.py

ADD activate-conda.sh /etc/profile.d/activate-conda.sh
# ADD sage-env.sh /etc/profile.d/00-sage-env.sh
ADD entrypoint /usr/local/bin/entrypoint

RUN mkdir $HOME/odk
WORKDIR $HOME/odk

ENTRYPOINT ["/usr/local/bin/entrypoint"]
