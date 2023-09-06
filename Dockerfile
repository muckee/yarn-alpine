###################
# STEP 1: Build the React app
###################
FROM alpine:latest AS build

# Create a user with the name 'node'
RUN addgroup -g 1000 node \
    && adduser -u 1000 -G node -s /bin/sh -D node

# Update APK libraries and packages
RUN apk update && apk upgrade

# Install dependencies and prepare Yarn
RUN apk add --no-cache git \
                       nodejs \
                       yarn \
    && yarn set version canary

# Initialise the yarn workspace
RUN mkdir -p packages \
    && yarn init -w

# Grant ownership of the `/home/node` directory to user 'node'
RUN chown -R node:node /home/node

# Default to user 'node'
USER node

# Set the `/home/node` directory as the current working directory
WORKDIR /home/node

# Assign the path `/home/node` to the environment variable `HOME`
ENV HOME=/home/node
