FROM node:lts-slim

WORKDIR /docs

COPY ./docs /docs

RUN set -x; rm -rf node_modules package-lock.yml \
    && npm install --registry=https://registry.npm.taobao.org