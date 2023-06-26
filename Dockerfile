###################
# STEP 1: Build the React app
###################
FROM alpine:latest AS build

# Update repositories and packages
RUN apk update \
    && apk upgrade

# Install dependencies
RUN apk add --no-cache nodejs \
                       corepack \
    && corepack prepare yarn@stable --activate

# Copy the repository files to the image
COPY ./workspace ./

# Line 1: Add support for `yarn workspaces foreach ...` by installing the `workspace-tools` plugin
# Line 2: Install the workspace
# Line 3: Build all the packages
# Line 4: Copy all of the build directories at `/src/workspace/packages/{package_name}/build/` to `/usr/share/{package_name}`
RUN yarn plugin import workspace-tools \
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
