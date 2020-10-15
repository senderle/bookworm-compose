FROM python:3.8-slim

WORKDIR /usr/src/app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        python3-dev \
        libmariadbclient-dev \
        wget \
        unzip

### FOR DEVELOPMENT ONLY--DROP OUT BEFORE PRODUCTION.
RUN apt-get install -y --no-install-recommends mariadb-client

RUN pip install --no-cache-dir numpy pandas \
        gunicorn bounter regex psutil mysqlclient

# Not used
COPY bookworm/put_password_in_config.sh ./
RUN sh put_password_in_config.sh

COPY ./bookworm/BookwormDB .
RUN pip install . .

# A different way of population the python module, not used.
#RUN wget https://github.com/Bookworm-project/BookwormDB/archive/master.zip \
#    && unzip master.zip \
#    && cd BookwormDB-master \
#    && pip install . .


# Makes the corpus ready.
WORKDIR /corpus
