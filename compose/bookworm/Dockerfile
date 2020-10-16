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

COPY ./bookworm/BookwormDB .
RUN pip install . .

# A different way of population the python module, not used.
#RUN wget https://github.com/Bookworm-project/BookwormDB/archive/master.zip \
#    && unzip master.zip \
#    && cd BookwormDB-master \
#    && pip install . .

# Must be run with passwords defined as environ variables.
COPY ./bookworm/setup_mysql_passwords.sh /usr/bin/setup_mysql_passwords

# Makes the corpus ready.
WORKDIR /corpus
