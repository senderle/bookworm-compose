# bookworm-compose

A docker-compose stack for bookworm. Separate volumes to
1. Serve a mysql bookworm instance with an API over gunicorn.
2. Publish that bookworm to http using nginx for both the raw API and the vega-lite visualizations. (The old line chart visualizations will need some tweaking, alas.)
3. Add ssl encryption.


## prerequisites

- [docker and docker compose](https://www.docker.com/products/docker-desktop)



## quick-ish start

A number of helper functions are contained in the bash scripts in `bin`. 

* `bin/build_bookworm [NAME]` creates a bookworm named [NAME].
* `bin/run dev` fires up a local server over nginx.
* `bin/run rebuild` clears the docker state. 

If you want to manage docker yourself, you can do the 
following:

```
# Create a persistent MySQL volume.
docker volume create --name=mysql_data

# Download required libraries.
bin/sync_libs

# Run the service, including a webhost over port 8020
docker-compose -f docker-compose.yml -f docker-compose.dev.yml up
```

This doesn't fill any bookworms. To do that, you need to populate the files at corpora and actually build an instance.

By default, each folder in corpora will be used as the name of a bookworm.

Be sure to choose a name without spaces and that is not a reserved keyword in mysql (FOR, EACH, FLOAT, that kind of thing.)

```
mkdir -p corpora

cp -r lib/bookwormDB/tests/test_bookworm_files/ corpora/test_bookworm_files

bin/build_bookworm test_bookworm_files
```

At this point, you've configured the docker stack and built a bookworm. The data is accessible on your
local machine via port 10013, if you wish to access the JSON API directly. 

Or go to [this link]( http://localhost:8020/#%7B%22plottype%22:%22pointchart%22,%22smoothingSpan%22:0,%22host%22:%22http://localhost:8020/%22,%22database%22:%22test_bookworm_files%22,%22aesthetic%22:%7B%22color%22:%22Search%22,%22x%22:%22TextCount%22,%22y%22:%22author%22%7D,%22search_limits%22:%5B%7B%22word%22:%5B%22on%22%5D%7D,%7B%22word%22:%5B%22upon%22%5D%7D%5D,%22vega%22:%7B%22title%22:%22Number%20of%20Federalist%20paper%20paragraphs%20by%20author.%22%7D%7D) to see a chart in your browser.


## Adding another bookworm.

If you want to add another one, you need to add another folder with bookworm inputs into `/corpora`.

Here's an example with state of the Union addresses.

```
wget http://benschmidt.org/SOTU_bundle.tar.gz
tar -xzvf SOTU_bundle.tar.gz
mv bundle/ corpora/SOTU
bin/build_bookworm SOTU
```

Now visit [this link](http://localhost:8020/#%7B%22plottype%22:%22linechart%22,%22smoothingSpan%22:0,%22host%22:%22http://localhost:8020/%22,%22database%22:%22SOTU%22,%22aesthetic%22:%7B%22color%22:%22Search%22,%22x%22:%22year%22,%22y%22:%22WordsPerMillion%22%7D,%22search_limits%22:%5B%7B%22word%22:%5B%22today%22%5D%7D,%7B%22word%22:%5B%22tonight%22%5D%7D%5D,%22vega%22:%7B%22title%22:%22SOTUs.%22%7D%7D)

You should get a line chart of words in State of the Union addresses.

## docker tips

Examine the scripts in `bin/` to get an idea how we intend docker be used.

The script `bin/run rebuild` will remove everything. `bin/run soft-rebuild` removes everything except the mysql volume, which can be the most expensive to repopulate.

## Security

Default root passwords for mysql are handled through docker secrets and stored at
`compose/mysql/dev_root_pw`
`compose/mysql/dev_user_pw`.

If you will be serving over the web, you should probably change these. There
are not major security vulnerabilities to using a public password in docker, but 
there could be.

The security for this is relatively tight. Once a bookworm is built, you can remove the associated files, and the only data in
the bookworm are wordcounts, which organizations like JStor and the Hathi Trust view as metadata that is protected under
fair use considerations. Additionally, the web server client does not have any write access to the underlying database; the MySQL root
password is used only for creating tables.
