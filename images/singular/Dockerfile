FROM jupyter/minimal-notebook@sha256:31c4e330d97bc475666968edda0967c4007345aafae8c876634d66bf5c7ac1bb

COPY environment.yml /tmp/environment.yml
RUN conda env update -y -f /tmp/environment.yml

