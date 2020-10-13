# bookworm-compose
A docker-compose stack for bookworm.

## quickstart

- create volume: `docker volume create --name=mysql_data`
- run containers: `$ docker-compose up -d`

Default root passwords for mysql are insecure and stored as
an environment variable in `docker-compose.yml`. If you wish
to use your own passwords or otherwise edit the docker-compose file,
create a new file at `docker-compose.override.yml` and paste (at least)
something like the following into it.


```
services:
  bookworm:
    environment:
      - MYSQL_ROOT_PASSWORD="my_secret"
  mariadb:
    environment:
      - MYSQL_ROOT_PASSWORD="my_secret"
```
