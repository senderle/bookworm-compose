# bookworm-compose
A docker-compose stack for bookworm.


## prerequisites

- [docker and docker compose](https://www.docker.com/products/docker-desktop)

Default root passwords for mysql are insecure and stored as
an environment variable in `docker-compose.yml`. Some are also stored in mysql config files.
It's a mess, will be fixed later. For now, just work with the included passwords.


## quick-ish start

```
# Create a persistent MySQL volume.
docker volume create --name=mysql_data
# Set the password. Note that if you change this here, it needs to be changed in several other places too.
bin/run set_mysql_password insecure_dev_password

# Run the service, including a webhost over port 8020
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

```

This doesn't fill any bookworms. To do that, you need to populate the files at corpus/ and build.

```
cp -r bookworm/BookwormDB/tests/test_bookworm_files/ corpus/
# Give the name the name the bookworm will run as
echo "[client]\ndatabase=test_bookworm_files" >> corpus/bookworm.cnf
# Build inside the API server container. (Should really be a different container, but for now...)
bin/run build_bookworm
```

At this point, you've configured the docker stack and built a bookworm. The data is accessible on your
local machine via port 10013, if you wish to access the JSON API directly. Or go to http://localhost:8020/vega/,
and replace the query in the box with this.

If you click 'draw plot', you should get barchart of federalist paper authors. If you build on some other corpus,
the queries that work will be different.

```json
{
  "plottype": "barchart",
  "smoothingSpan": 0,
  "host": "http://localhost:8020/",
  "database": "test_bookworm_files",
  "aesthetic": {
    "x": "TextCount",
    "y": "author"
  },
  "search_limits": {},
  "vega": {
    "title": "Number of mederalist papers by author."
  }
}
```




  ## docker tips
  - __tear down docker-compose setup__: `$ docker-compose down --rmi all --volumes --remove-orphans` (this will remove containers, images, and non-external volumes, and will inform you why a resource could not be destroyed, if applicable)
  - [cheat sheet](https://dockerlabs.collabnix.com/docker/cheatsheet/)


## secrets

Default root passwords for mysql are insecure and stored as an environment variable in `docker-compose.yml`. If you wish to use your own passwords or otherwise edit the docker-compose file, create a new file at `docker-compose.override.yml` and paste (at least) something like the following into it.



If you wish
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
