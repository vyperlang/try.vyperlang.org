FROM jupyter/base-notebook:latest
USER root

# Install git and curl
RUN apt-get update && \
    apt-get install -yqq git curl && \
    apt-get clean

# Install zksync binary dependencies
RUN curl --location https://raw.githubusercontent.com/matter-labs/zkvyper-bin/66cc159d9b6af3b5616f6ed7199bd817bf42bf0a/linux-amd64/zkvyper-linux-amd64-musl-v1.4.0 \
    --silent --output /usr/local/bin/zkvyper && \
    chmod +x /usr/local/bin/zkvyper && \
    zkvyper --version
RUN curl --location https://github.com/matter-labs/era-test-node/releases/download/v0.1.0-alpha.19/era_test_node-v0.1.0-alpha.19-x86_64-unknown-linux-gnu.tar.gz \
    --silent --output era_test_node.tar.gz && \
    tar --extract --file=era_test_node.tar.gz && \
    mv era_test_node /usr/local/bin/era_test_node && \
    era_test_node --version && \
    rm era_test_node.tar.gz

# Install boa and zksync. Install boa after so we can install another version.
USER ${NB_UID}
ARG ZKSYNC_FORK=DanielSchiavini
ARG ZKSYNC_REF=main
RUN pip install git+https://github.com/$ZKSYNC_FORK/titanoboa-zksync.git@$ZKSYNC_REF
ARG FORK=vyperlang
ARG REF=master
RUN pip install git+https://github.com/$FORK/titanoboa.git@$REF
RUN jupyter lab extension enable boa

# switch back to root so that the start script
# (https://github.com/jupyter/docker-stacks/blob/c2159f41/images/docker-stacks-foundation/start.sh)
# can set permissions correctly before dropping into jovyan.
USER root

# Copy config
COPY start-notebook.d/* /usr/local/bin/start-notebook.d/
COPY config/ipython_config.py /etc/ipython/ipython_config.py
