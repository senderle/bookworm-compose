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
local machine via port 10013, if you wish to access the JSON API directly. 

Or go to http://localhost:8020/#{%20%22plottype%22:%20%22pointchart%22,%20%22smoothingSpan%22:%200,%20%22host%22:%20%22http://localhost:8020/%22,%20%22database%22:%20%22test_bookworm_files%22,%20%22aesthetic%22:%20{%20%22x%22:%20%22TextCount%22,%20%22y%22:%20%22author%22%20},%20%22search_limits%22:%20[{%22word%22:%20[%22the%22]}],%20%22vega%22:%20{%20%22title%22:%20%22Number%20of%20Federalist%20paper%20paragraphs%20by%20author.%22%20}%20
.


## Adding another bookworm.

If you want to add another one, you need to clear build info out of the `/corpus` folder before running `build_bookworm`.

Here's an example with state of the Union addresses.

```
rm -rf corpus/.bookworm
wget http://benschmidt.org/SOTU_bundle.tar.gz
tar -xzvf SOTU_bundle.tar.gz
mv bundle/* corpus
echo "[client]" > corpus/bookworm.cnf
echo "database=SOTU" >> corpus/bookworm.cnf
bin/run build_bookworm
```

Now visit [this link](http://localhost:8020/#%7B%22plottype%22:%22linechart%22,%22smoothingSpan%22:0,%22host%22:%22http://localhost:8020/%22,%22database%22:%22SOTU%22,%22aesthetic%22:%7B%22color%22:%22Search%22,%22x%22:%22year%22,%22y%22:%22WordsPerMillion%22%7D,%22search_limits%22:%5B%7B%22word%22:%5B%22today%22%5D%7D,%7B%22word%22:%5B%22tonight%22%5D%7D%5D,%22vega%22:%7B%22title%22:%22Number%20of%20Federalist%20paper%20paragraphs%20by%20author.%22%7D%7D)

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
