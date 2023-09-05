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
    && yarn set version canary

RUN mkdir -p /home/node/packages \
    && cd /home/node \
    && yarn init -w \
    && yarn install \
    && chown -R node:node /home/node

ENV HOME=/home/node

USER node

WORKDIR /workspace
