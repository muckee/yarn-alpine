###################
# STEP 1
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

# Update Yarn
RUN yarn set version stable

WORKDIR /src

# Copy the repository files to the image
COPY ./app ./

# Install and build the React application
RUN yarn install --immutable \
    && yarn run build

###################
# STEP TWO
###################
FROM quay.io/muck/go-scratch:latest AS final

COPY --from=build /src/build /
 
ENTRYPOINT ["/index.html"]
