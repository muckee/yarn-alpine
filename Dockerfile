ARG GO_VERSION=1.20

###################
# STEP 1
###################
FROM golang:${GO_VERSION}-alpine AS build

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

# Initialise Go package
COPY ./go.mod ./
RUN go mod download

# Copy the repository files to the image
COPY ./ ./

WORKDIR /app

# Install and build the React application
RUN yarn install --immutable \
    && yarn run build \
    && mv /app/build/. /src/cmd/app/public/

WORKDIR /src

# Run tests
# RUN CGO_ENABLED=0 go test -timeout 30s -v github.com/gbaeke/go-template/pkg/api
 
# Build the Go executable
RUN CGO_ENABLED=0 go build \
    -installsuffix 'static' \
    -o /app ./cmd/app

###################
# STEP TWO
###################
FROM scratch AS final

COPY --from=build /app /app
 
# copy ca certs
COPY --from=build /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
 
# copy users from builder (use from=0 for illustration purposes)
COPY --from=0 /etc/passwd /etc/passwd
 
# Assign the filesystem user
USER appuser
 
ENTRYPOINT ["/app"]
