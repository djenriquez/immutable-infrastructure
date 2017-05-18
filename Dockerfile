FROM python:3.6-slim

MAINTAINER DJ Enriquez <dj@glympse.com>

RUN pip install awscli

COPY src/sync.sh /sync.sh

ARG BUCKET_PATH
ENV BUCKET_PATH ${BUCKET_PATH}

COPY . /etc/immutable-infrastructure/

ENTRYPOINT ["/bin/bash", "-c"]