FROM jupyter/base-notebook:latest
USER root

RUN apt-get update && \
    apt-get install -yqq git && \
    apt-get clean

# install titanoboa into user env
USER ${NB_UID}
ARG FORK=vyperlang
ARG REF=master
RUN pip install git+https://github.com/$FORK/titanoboa.git@$REF
RUN jupyter lab extension enable boa

# switch back to root so that the start script
# (https://github.com/jupyter/docker-stacks/blob/c2159f41/images/docker-stacks-foundation/start.sh)
# can set permissions correctly before dropping into jovyan.
USER root

COPY start-notebook.d/* /usr/local/bin/start-notebook.d/
COPY config/ipython_config.py /etc/ipython/ipython_config.py
