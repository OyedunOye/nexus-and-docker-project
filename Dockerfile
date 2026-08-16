FROM node:20-alpine

ENV MONGO_DB_USERNAME=mongoadmin \
    MONGO_DB_PWD=password

RUN mkdir -p /home/app

# set source directory as ./app/docker-app-local while building my-app:1.0 image and as ./app/docker-app-server while building my-app:3.0
COPY ./app/docker-app-local /home/app

# set default dir so that next commands executes in /home/app dir
WORKDIR /home/app

# will execute npm install in /home/app because of WORKDIR
RUN npm install

# no need for /home/app/server.js because of WORKDIR
CMD ["node", "server.js"]
