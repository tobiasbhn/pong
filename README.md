# PONG
This Project ...
## Getting Started
Clone this Repo locally:
```
$ git clone https://github.com/tobiasbhn/pong.git
$ cd pong
```

## Prerequisites
For using PONG with docker you need to install docker and docker-compose.
You will find detailed information on how to install the docker dependencies here:
* [Docker](https://docs.docker.com/install/)
* [Docker-Compose](https://docs.docker.com/compose/install/)



## docker & docker-compose
Build Image:
```bash
DOCKER_BUILDKIT=1 docker build . -t pong_web:dev --target development --build-arg RAILS_MASTER_KEY=XXXXXXXXXXXX
DOCKER_BUILDKIT=1 docker build . -t pong_web:prod --target production --build-arg RAILS_MASTER_KEY=XXXXXXXXXXXX
```

Start Container:
```bash
docker-compose up -d
docker-compose -f docker-compose.yml -f docker-compose.production.yml up -d
```

Stop container:
```bash
docker-compose down
```

Bash into Container
```bash
docker ps
docker exec -it <CONTAINER ID> /bin/bash
```
