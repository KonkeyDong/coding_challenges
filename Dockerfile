FROM debian:latest

RUN apt update --yes && \
    apt upgrade --yes && \
    apt install --yes vim

WORKDIR /app
COPY . /app

