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

# Set the working directory for the image
WORKDIR /src

# Copy the `app/` folder from the git repository into the working directory
COPY ./app ./app

# Install and build the React application
RUN cd ./app \
    && yarn install --immutable \
    && yarn run build

###################
# STEP TWO
###################
FROM scratch AS final

# Copy the HTML application from the build image
COPY --from=build /src/app/build /app
 
# Assign the filesystem user
USER appuser
 
ENTRYPOINT ["/app/index.html"]
