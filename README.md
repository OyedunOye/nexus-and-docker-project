## demo app - developing with Docker

This demo app shows a simple user profile app set up using

- index.html with pure js and css styles
- nodejs backend with express module
- mongodb for data storage

All components are docker-based

### With Docker

#### To start the application

Step 1: Create docker network

    docker network create mongo-network

Step 2: start mongodb

    docker run -d -p 27017:27017 -e MONGO_INITDB_ROOT_USERNAME=mongoadmin -e MONGO_INITDB_ROOT_PASSWORD=password --name mongodb --net mongo-network mongo

Step 3: start mongo-express

    docker run -d -p 8081:8081 -e ME_CONFIG_MONGODB_ADMINUSERNAME=mongoadmin -e ME_CONFIG_MONGODB_ADMINPASSWORD=password -e ME_CONFIG_BASICAUTH_USERNAME=user -e ME_CONFIG_BASICAUTH_PASSWORD=pass --net mongo-network --name mongo-express -e ME_CONFIG_MONGODB_SERVER=mongodb -e ME_CONFIG_MONGODB_URL=mongodb://mongodb:27017 mongo-express

_NOTE: creating docker-network in optional. You can start both containers in a default network. In this case, just omit `--net` flag in `docker run` command_

Step 4: open mongo-express from browser

    http://localhost:8081

Step 5: create `user-account` _db_ and `users` _collection_ in mongo-express

Step 6: Start your nodejs application locally - go to `app` directory of project

    cd app
    npm install
    node server.js

Step 7: Access you nodejs application UI from browser

    http://localhost:3000

### With Docker Compose

#### To start the application

Step 1: start mongodb and mongo-express

    docker-compose -f docker-compose.yaml up

_You can access the mongo-express under localhost:8080 from your browser_

Step 2: in mongo-express UI - create a new database "user-account"

Step 3: in mongo-express UI - create a new collection "users" in the database "user-account"

Step 4: start node server

    cd app
    npm install
    node server.js

Step 5: access the nodejs application from browser

    http://localhost:3000

#### To build a docker image from the application

    docker build -t my-app:1.0 .

The dot "." at the end of the command denotes location of the Dockerfile.

Note that the only needed files for docker image that was run on local was copied into /app/docker-app-local directory, while one run on server is copied docker-app-server to prevent copying unnecessary files to the image while building from Dockerfile. npm install creates fresh package-lock.json and node_modules, no need to copy the one from local.

## Differences between local and server code base:

1. server.js: Local uses mongoUrlLocal when starting application locally with node command while server image uses mongoUrlDockerCompose as the mongodb connection string when starting application as docker container, part of docker-compose

2. index.html: http://localhost:3000/ for locally run app(my-app:1.0) while http://178.105.179.238:3000/ to build image run on the server(my-app:3.0).

Both versions of docker image were pushed to nexus docker-hosted repo.

### Run app locally and on server with docker-compose.yaml

Run app with docker-compose.yaml which pulls mongo and mongo express image from docker hub and my-app image from nexus repo, run all images from the same docker network. The docker command is:
