# bookworm-compose

A docker-compose stack for bookworm. Separate volumes to
1. Serve a mysql bookworm instance with an API over gunicorn.
2. Publish that bookworm to http using nginx for both the raw API and the vega-lite visualizations. (The old line chart visualizations will need some tweaking, alas.)
3. Add ssl encryption.


## prerequisites

- [docker and docker compose](https://www.docker.com/products/docker-desktop)

Default root passwords for mysql are handled through docker secrets and stored at
`compose/mysql/dev_root_pw`
`compose/mysql/dev_user_pw`.

A number of helper functions are contained in the bash script `bin/run`. 
* `build_bookworm` creates a bookworm.
* `dev` fires up a local server over nginx.

## quick-ish start

```
# Create a persistent MySQL volume.
docker volume create --name=mysql_data

# Run the service, including a webhost over port 8020
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up

# I populate my own passwords in docker-compose.override.yml, so run:
# docker-compose -f docker-compose.yml -f docker-compose.override.yml -f docker-compose.dev.yml up


```

This doesn't fill any bookworms. To do that, you need to populate the files at corpus/ and build.

```
cp -r bookworm/BookwormDB/tests/test_bookworm_files/ corpus/
# Give the name the name the bookworm will run as

echo "[client]" > corpus/bookworm.cnf
echo "database=test_bookworm_files" >> corpus/bookworm.cnf

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
    "title": "Number of Federalist paper paragraphs by author."
  }
}
```




## docker tips

- __tear down docker-compose setup__: `$ docker-compose down --rmi all --volumes --remove-orphans` (this will remove containers, images, and non-external volumes, and will inform you why a resource could not be destroyed, if applicable)
- [cheat sheet](https://dockerlabs.collabnix.com/docker/cheatsheet/)

The script `bin/run rebuild` will remove everything. `bin/run soft-rebuild` removes everything except the mysql volume, which can be the most expensive to repopulate.

## MySQL users.

The security for this is relatively tight. Once a bookworm is built, you can remove the associated files, and the only data in
the bookworm are wordcounts, which organizations like JStor and the Hathi Trust view as metadata that is protected under
fair use considerations. Additionally, the web server client does not have any write access to the underlying database; the MySQL root
password is used only for creating tables.

## secrets



If you wish to use your own passwords or otherwise edit the docker-compose file,
create a new file at `docker-compose.override.yml` do so there.
