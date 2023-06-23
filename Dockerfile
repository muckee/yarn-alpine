 
# STAGE 1: build the react application
FROM alpine:latest AS build
RUN apk update \
    && apk upgrade \
    && apk add --no-cache curl \
                          nodejs \
                          yarn

RUN yarn set version latest

# Add user here. Cannot be added in scratch
RUN addgroup -S appuser \
    && adduser -S -u 10000 -g appuser appuser \
    && mkdir /app

WORKDIR /src

# Copy the `app/` folder from the git repository into the working directory
COPY ./app ./

# Install and build the React application
RUN cd ./app \
    && yarn install \
    && yarn run build

# STAGE 2: build the scratch image
FROM scratch AS final

# Copy the HTML application from the build image
COPY --from=build /src/app/build /app
 
USER appuser
 
ENTRYPOINT ["/app"]
