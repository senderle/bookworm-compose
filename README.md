# bookworm-compose
A docker-compose stack for bookworm.

## prerequisites

- [docker and docker compose](https://www.docker.com/products/docker-desktop)

## quickstart

- clone and change directory into repository
- create mysql volume with
  `$ docker volume create --name=mysql_data`
- create and run containers in detached mode with
  `$ docker-compose up -d`

## secrets

Default root passwords for mysql are insecure and stored as an environment variable in `docker-compose.yml`. If you wish to use your own passwords or otherwise edit the docker-compose file, create a new file at `docker-compose.override.yml` and paste (at least) something like the following into it.


```
services:
  bookworm:
    environment:
      - MYSQL_ROOT_PASSWORD="my_secret"
  mariadb:
    environment:
      - MYSQL_ROOT_PASSWORD="my_secret"
```

## docker tips
- __tear down docker-compose setup__: `$ docker-compose down --rmi all --volumes --remove-orphans` (this will remove containers, images, and non-external volumes, and will inform you why a resource could not be destroyed, if applicable)
- [cheat sheet](https://dockerlabs.collabnix.com/docker/cheatsheet/)
