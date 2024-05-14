FROM python:3.10-alpine

WORKDIR /src

RUN apk add --no-cache gcc curl musl-dev linux-headers librdkafka-dev bash

RUN apk add --no-cache --virtual .make-deps bash make wget git gcc g++ && apk add --no-cache musl-dev zlib-dev openssl zstd-dev pkgconfig libc-dev
RUN wget https://github.com/edenhill/librdkafka/archive/v2.4.0.tar.gz
RUN tar -xvf v2.4.0.tar.gz && cd librdkafka-2.4.0 && ./configure --prefix /usr && make && make install

RUN pip install --upgrade pip \
    && pip install requests confluent_kafka pyyaml

RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin

COPY src /src

CMD ["python3", "-u", "main.py"]
