# Configuration file for jupyterhub.

c = get_config()  #noqa

import os

#c.Application.log_level = 'DEBUG'

import oauthenticator.github
c.JupyterHub.authenticator_class = oauthenticator.github.GitHubOAuthenticator
c.GitHubOAuthenticator.oauth_callback_url = os.environ['OAUTH_CALLBACK_URL']
c.GitHubOAuthenticator.allow_all = True  # https://github.com/jupyterhub/oauthenticator/pull/625


# Persist hub data on volume mounted inside container
c.JupyterHub.cookie_secret_file = "/data/jupyterhub_cookie_secret"
c.JupyterHub.db_url = "sqlite:////data/jupyterhub.sqlite"

import dockerspawner

# adapted from
# https://github.com/jupyterhub/jupyterhub-deploy-docker/blob/89a296290166/basic-example/jupyterhub_config.py


# We rely on environment variables to configure JupyterHub so that we
# avoid having to rebuild the JupyterHub container every time we change a
# configuration parameter.

# Spawn single-user servers as Docker containers
c.JupyterHub.spawner_class = dockerspawner.DockerSpawner

# Spawn containers from this image
c.DockerSpawner.image = os.environ["DOCKER_NOTEBOOK_IMAGE"]

# JupyterHub requires a single-user instance of the Notebook server, so we
# default to using the `start-singleuser.sh` script included in the
# jupyter/docker-stacks *-notebook images as the Docker run command when
# spawning containers.  Optionally, you can override the Docker run command
# using the DOCKER_SPAWN_CMD environment variable.
spawn_cmd = os.environ.get("DOCKER_SPAWN_CMD", "start-singleuser.sh")
c.DockerSpawner.cmd = spawn_cmd

c.DockerSpawner.environment = {
    "CHOWN_HOME": "yes",
    "CHOWN_HOME_OPTS": "-R",
    # use /lab instead of /tree as the default URL, so the shareable links work properly
    "JUPYTERHUB_DEFAULT_URL": "/lab",
}

# classic notebook
c.Spawner.default_url = "/tree"

# Connect containers to this Docker network
network_name = os.environ["DOCKER_NETWORK_NAME"]
c.DockerSpawner.use_internal_ip = True
c.DockerSpawner.network_name = network_name

# Explicitly set notebook directory because we'll be mounting a volume to it.
# Most `jupyter/docker-stacks` *-notebook images run the Notebook server as
# user `jovyan`, and set the notebook directory to `/home/jovyan/work`.
# We follow the same convention.
notebook_dir = "/home/jovyan"
c.DockerSpawner.notebook_dir = notebook_dir

# Mount the real user's Docker volume on the host to the notebook user's
# notebook directory in the container
pwd = os.environ["PWD"]
c.DockerSpawner.volumes = {
    # mount the user's home directory
    pwd + "/data/userdirs/jupyter-{raw_username}": notebook_dir,
    # mount the user shared directory (including other user's public dirs)
    pwd + "/data/shared": {"bind": "/home/shared", "mode": "ro"},
    # mount the user's own directory as read-write
    pwd + "/data/shared/{raw_username}": "/home/shared/{raw_username}",
    # mount the default demos directory
    pwd + "/demos": {"bind": "/home/demos", "mode": "ro"},
}

# Remove containers once they are stopped
# COMMENT OUT THIS LINE TO DEBUG CONTAINER ISSUES!
c.DockerSpawner.remove = True

# For debugging arguments passed to spawned containers
c.DockerSpawner.debug = True

c.DockerSpawner.cpu_limit = 1
c.DockerSpawner.mem_limit = "512M"

# User containers will access hub by container name on the Docker network
c.JupyterHub.hub_ip = "0.0.0.0"
c.JupyterHub.hub_connect_ip = os.environ["HUB_CONNECT_IP"]

# add an announcement to all pages. See https://github.com/jupyterhub/jupyterhub/blob/135be72470b/docs/source/howto/templates.md?plain=1#L68
c.JupyterHub.template_vars = {
    "announcement":
        """
        Welcome to the Vyper JupyterLab environment.
        This is a free service provided by the Vyper team.
        This service is provided free of charge and with no warranty.
        Please use it responsibly.
        Misuse of this service will result in a permanent ban.
        """,
}
