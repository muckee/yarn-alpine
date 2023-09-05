###################
# STEP 1: Build the React app
###################
FROM alpine:latest AS build

# Update repositories and packages
RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node \
    && apk update && apk upgrade

# Install dependencies and prepare Yarn
RUN apk add --no-cache git \
                       nodejs \
                       yarn \
                       npm \
    && yarn set version canary \
    && npm i -g npx \
    && rm -f /package.json

RUN mkdir -p /workspace \
    && cd /workspace \
    && yarn init -w \
    && chown -R node:node /workspace

ENV HOME=/home/node

USER node

WORKDIR /workspace
