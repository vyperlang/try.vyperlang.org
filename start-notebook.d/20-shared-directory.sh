#!/usr/bin/env bash

# create a soft link to the shared directory
# if we use a volume, the startup script crashes trying to take ownership
[ -d /home/jovyan/shared ] || ln -s /home/shared /home/jovyan/shared

# transfer ownership of the shared directory's user folder.
# the base startup script tries to chown the user's whole home directory, but
# it doesn't follow symlinks. we can't just tell the startup script to
# `chown --recursive -L` because `/home/shared` is a read-only volume, it only
# works with the right username, which we don't have access to in the base
# startup script.
chown --recursive ${NB_UID}:${NB_GID} /home/shared/${JUPYTERHUB_USER}
