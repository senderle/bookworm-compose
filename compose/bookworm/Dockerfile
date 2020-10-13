FROM python:3.8-slim

WORKDIR /usr/src/app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        python3-dev \
        libmariadbclient-dev \
        wget \
        unzip

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt
COPY bookworm/bookworm.py bookworm.py

RUN wget https://github.com/Bookworm-project/BookwormDB/archive/master.zip \
    && unzip master.zip \
    && cd BookwormDB-master \
    && pip install . .

COPY bookworm/put_password_in_config.sh ./
RUN sh put_password_in_config.sh

EXPOSE 10012
