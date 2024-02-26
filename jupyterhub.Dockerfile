FROM python:3.11-slim

RUN apt-get update
RUN apt-get install -yqq --no-install-recommends \
        curl \
        git \
        build-essential

# install configurable-http-proxy, required for jupyter
RUN apt-get install -yqq --no-install-recommends \
	curl \
	ca-certificates \
	gnupg

RUN mkdir -p /etc/apt/keyrings

RUN curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg

RUN echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_20.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list

RUN apt-get update
RUN apt-get install -yqq nodejs

RUN npm install -g yarn configurable-http-proxy@^4.2.0

RUN pip install jupyter jupyterhub jupyterlab
RUN pip install oauthenticator dockerspawner

# DEBUG
#COPY jupyterhub/ /root/jupyterhub
#COPY oauthenticator/ /root/oauthenticator
#ENV PYTHONPATH=/root/jupyterhub:/root/oauthenticator

#RUN pip install git+https://github.com/vyperlang/titanoboa.git

# this is overridden when running in compose, it is here for a valid image build
COPY ./config/jupyterhub_config.py /etc/jupyterhub/jupyterhub_config.py

CMD ["jupyterhub", "-f", "/etc/jupyterhub/jupyterhub_config.py", "--upgrade-db"]
