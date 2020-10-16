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

RUN echo "[client]" > /etc/bookworm/admin.cnf
RUN echo "user=root" >> /etc/bookworm/admin.cnf
RUN echo "password_file=/run/secrets/mysql_user_pw" >> /etc/bookworm/admin.cnf
RUN echo "host=mariadb" >> /etc/bookworm/admin.cnf
RUN echo "clienthostname=" >> /etc/bookworm/admin.cnf

RUN echo "[client]" > /etc/bookworm/client.cnf
RUN echo "user=bookworm" >> /etc/bookworm/client.cnf
RUN echo "password_file=/run/secrets/mysql_user_pw" >> /etc/bookworm/client.cnf
RUN echo "host=mariadb" >> /etc/bookworm/client.cnf
RUN echo "clienthostname=" >> /etc/bookworm/client.cnf

# Makes the corpus ready.
WORKDIR /corpus
