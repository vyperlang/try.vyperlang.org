# Vyper JupyterHub
Hosted at [try.vyperlang.org](https://try.vyperlang.org)

This project uses Docker to manage its services. The `docker-compose.yaml` file defines the services that make up your app so they can be run together in an isolated environment.

## Docker compose services

The project consists of two main services:

1. `notebook-image`: This service is built from the `notebook.Dockerfile` and is used to create a Docker image named `titanoboa-notebook`.
This image is not run as a service but is used by the `vypyter` service.

2. `vypyter`: This service is built from the `jupyterhub.Dockerfile` and depends on the `notebook-image` service.
It exposes port 8000 and uses environment variables defined in the `.env` file and additional ones defined in the `docker-compose.yaml` file.

## Getting Started

To run the project locally, you need to follow these steps:

1. Ensure Docker and Docker Compose are installed on your machine. If not, you can download them from the official Docker website.

2. Clone the project repository to your local machine using Git.

3. [Create a GitHub OAuth app](https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/creating-an-oauth-app) and add to a new `.env` file:
   - ```
     GITHUB_CLIENT_ID=...
     GITHUB_CLIENT_SECRET=...`
     GITHUB_CALLBACK_URL=http://localhost:8000/hub/oauth_callback
     ```

4. You can start the JupyterHub using Docker Compose.
Run the command `docker compose up` to start it in the foreground, or `docker compose up --detach` to start in the background.

   - This command automatically builds the necessary images if they don't exist.
   - To build them manually, you can run `docker compose build`.
   - To build and run immediately, you can run `docker compose up --build`.
   - The `FORK` and `REF` environment variables can be used to specify the Titanoboa fork and branch/commit to use.
    The default is to use the `master` branch of the [`titanoboa` repository](https://github.com/vyperlang/titanoboa/tree/master).
   - The `PORT` environment variable can be used to specify the port to expose.
    The default is `8000`.

5. The `vypyter` service should now be running and accessible at `http://localhost:8000`.

## GitHub Actions
In order to run the GitHub Actions, you need to add the following secrets to your repository:
- `AUTH_SSH_USER`: The username used to authenticate with the server.
- `AUTH_SSH_KEY`: The private SSH key used to authenticate with the server.

Also, you need to add the following (environment) action variables to your repository:
- `HOST`: The hostname of the server.
- `HOST_PUBLIC_KEY`: The public SSH key used to authenticate with the server.
  This is used to verify the server's identity when connecting via SSH.
  You can find the public key by calling `ssh-keyscan`.
- `REPO_DIR`: The directory where the repository is be cloned on the server.
    For example, `~/try.vyperlang.org`.
- `BOA_COMMIT_ISH`: The commit-ish to checkout on the server.
    By default, `master`.
- `PORT`: The port to expose the JupyterHub on the server.
    By default, `8000`.
- `JUPYTERHUB_IMAGE_NAME`: Optional environment variable to specify the name of the JupyterHub image.
    By default, `jupyterhub`. 
- `NOTEBOOK_IMAGE_NAME`: Optional environment variable to specify the name of the notebook image.
    By default, `titanoboa-notebook`.
