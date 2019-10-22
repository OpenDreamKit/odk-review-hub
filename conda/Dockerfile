FROM condaforge/linux-anvil-comp7

ENV PATH=/opt/conda/bin:$PATH

COPY recipes/flint2 recipes/flint2
RUN conda build recipes/flint2

COPY recipes/singular recipes/singular
RUN conda build recipes/singular

ENTRYPOINT []
