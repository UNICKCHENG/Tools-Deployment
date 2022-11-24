# see https://github.com/pengx17/logseq-publish

FROM ghcr.io/logseq/logseq-webapp:latest as web

FROM ghcr.io/unickcheng/logseq-publish-slim:master as logseq

FROM mcr.microsoft.com/playwright:focal

WORKDIR /home/logseq

COPY --from=web /usr/share/nginx/html ./public
COPY --from=logseq /home/logseq/public/static/node_modules ./public/static/node_modules
COPY --from=logseq /home/logseq/node_modules ./node_modules
COPY --from=logseq /home/logseq/publish.mjs ./