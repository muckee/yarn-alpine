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
COPY ./workspace ./
# COPY ./package ./


# Line 1: Update Yarn to latest table version
# Line 2: Add support for `yarn workspaces foreach ...` by installing the `workspace-tools` plugin
# Line 3: Install the workspace
# Line 4: Build all the packages
# Line 5: Copy all of the build directories at `/src/workspace/packages/{package_name}/build/` to `/usr/share/{package_name}`
RUN yarn set version stable \
    && yarn plugin import workspace-tools \
    && yarn install --immutable \
    && yarn workspaces foreach run build \
    && for file in `find ./packages \
		         -maxdepth 1 \
                         -type d \
                         -not \( -path '.' -type d \) \
                         -not \( -path './packages' -type d \) \
                         -exec basename {} \;`; \
                         do cp -r ./packages/"$file"/build /usr/share/"$file"; \
                         done
