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
