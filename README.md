# PONG
This Project ...
## Getting Started
Clone this Repo locally:
```
$ git clone https://github.com/tobiasbhn/pong.git
$ cd pong
```
### Docker
Install Docker & Docker-Compose
* [Docker](https://docs.docker.com/install/)
* [Docker-Compose](https://docs.docker.com/compose/install/)
## Using
### Setup Project:
```
pwd: .../pong
$ docker-compose build
```
Start Containers:
```
pwd: .../pong
$ docker-compose up (with console output)
$ docker-compose up -d (detached-mode: without console output)
```
### List Images & Containers
List Containers:
```
$ docker ps
$ docker container ls
```
List Images:
```
$ docker images ls
```
### Enter running Container
Live View Console Output:
```
$ docker ps
-> CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
-> 0afe60f469eb        pong_web            "entrypoint.sh rails…"   34 minutes ago      Up 34 minutes       0.0.0.0:3000->3000/tcp   pong_web_1
-> ...
$ docker logs 0afe60f469eb -f
```
Enter Rails Console:
```
$ docker ps
-> CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                    NAMES
-> 0afe60f469eb        pong_web            "entrypoint.sh rails…"   34 minutes ago      Up 34 minutes       0.0.0.0:3000->3000/tcp   pong_web_1
-> ...
$ docker exec -it 0afe60f469eb /bin/bash
$ rails c
```
