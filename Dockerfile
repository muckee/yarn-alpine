###################
# STEP 1: Build the React app
###################
FROM alpine:latest AS build

# Update repositories and packages
RUN apk update \
    && apk upgrade

# Install dependencies
RUN apk add --no-cache nodejs \
                       yarn

# Copy the repository files to the image
COPY ./package ./

# Update Yarn
RUN yarn set version stable \
    && yarn install --immutable \
    && yarn run build \
    && cp -r build /usr/share/react-ui
