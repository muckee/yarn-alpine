###################
# STEP 1: Build the React app
###################
FROM alpine:latest AS build

# Add user
RUN addgroup -S appuser \
    && adduser -S -u 10000 -g appuser appuser

# Update repositories and packages
RUN apk update \
    && apk upgrade

# Install dependencies
RUN apk add --no-cache nodejs \
                       yarn

WORKDIR /src

# Copy the repository files to the image
COPY ./package ./

# Update Yarn
RUN yarn set version stable \
    && yarn install --immutable \
    && yarn run build \
    && cp build/. /usr/local/
