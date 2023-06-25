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
RUN apk add --no-cache ca-certificates \
                       nodejs \
                       yarn

# Update Yarn
RUN yarn set version stable

WORKDIR /src

# Copy the repository files to the image
COPY ./package ./

# Install and build the React application, then move it to the `/app` directory
RUN yarn install --immutable \
    && yarn run build \
    && rm -rf /app/.* \
    && mv ./build/. /app/
