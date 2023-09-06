###################
# STEP 1: Build the React app
###################
FROM alpine:latest AS build

# Create a user with the name 'yarn'
RUN addgroup -g 1000 yarn \
    && adduser -u 1000 -G yarn -s /bin/sh -D yarn

# Update APK libraries and packages
RUN apk update && apk upgrade

# Prepare the environment
RUN apk add --no-cache git \
                       nodejs \
                       yarn

# Update Yarn
RUN yarn set version canary

# Cleanup Yarn
RUN rm /package.json

# Set the `/home/yarn` directory as the current working directory
WORKDIR /home/yarn

# Grant ownership of the `/home/yarn` directory to user 'yarn'
RUN chown -R yarn:yarn /home/yarn

# Assign the path `/home/yarn` to the environment variable `HOME`
ENV HOME=/home/yarn

# Default to user 'yarn'
USER yarn
