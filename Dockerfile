###################
# STEP 1: Build the React app
###################
FROM alpine:latest AS build

# Update repositories and packages
RUN apk update \
    && apk upgrade

# Install dependencies and prepare Yarn
RUN apk add --no-cache nodejs \
                       yarn \
    && yarn set version canary

WORKDIR /src

# Copy the repository files to the image
COPY ./workspace ./

# Install the workspace
# Build all the packages
# Copy all of the build directories at `/src/workspace/packages/{package_name}/build/` to `/usr/share/{package_name}`
RUN yarn install --immutable \
    && yarn workspaces foreach run build \
    && for file in `find ./packages \
		         -maxdepth 1 \
                         -type d \
                         -not \( -path '.' -type d \) \
                         -not \( -path './packages' -type d \) \
                         -exec basename {} \;`; \
                         do cp -r ./packages/"$file"/build /usr/share/"$file"; \
                         done
