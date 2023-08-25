###################
# STEP 1: Build the React app
###################
FROM alpine:latest AS build

# Update repositories and packages
RUN apk update \
    && apk upgrade

# Install dependencies and prepare Yarn
RUN apk add --no-cache git \
                       nodejs \
                       yarn \
    && yarn set version canary

RUN mkdir -p /workspace \
    && cd /workspace \
    && yarn init -w

WORKDIR /workspace
