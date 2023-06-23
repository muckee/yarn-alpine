 
# STAGE 1: build the react application
FROM alpine:latest AS build
RUN apk update \
    && apk upgrade \
    && apk add --no-cache curl \
                          nodejs \
                          npm

RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v18.16.0/install.sh | bash

# install node and npm
RUN source /usr/local/nvm/nvm.sh \
    && nvm install 18.16.0 \
    && nvm alias default 18.6.0 \
    && nvm use default

# Add user here. Cannot be added in scratch
RUN addgroup -S appuser \
    && adduser -S -u 10000 -g appuser appuser \
    && mkdir /app

# Build React app
WORKDIR /app

COPY ./app/* ./app

RUN cd ./app && yarn install \
    && yarn run build \
    && cp build/* /app/ \
    && cd /app \
    && rm -rf app

# STAGE 2: build the container to run
FROM scratch AS final

COPY --from=build /app /app
 
USER appuser
 
ENTRYPOINT ["/app"]
