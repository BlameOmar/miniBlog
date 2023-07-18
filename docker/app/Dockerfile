# ================================
# Build image
# ================================
FROM swift:5.8-jammy as build

# Install OS updates.
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y\
    && rm -rf /var/lib/apt/lists/*

# Set up a workspace and copy files necessary for building the package.
WORKDIR /workspace/src
COPY ./Package.* ./
COPY ./Sources ./Sources
COPY ./Tests ./Tests

# Build everything in release mode.
# We disable the shared dependency and manifest caches to force all intermediary files to be written
# to /workspace/build, which is a docker cache-mount. This speeds up subsequent builds, since most
# files will not have changed.
RUN --mount=type=cache,target=/workspace/build \
    swift build \
    --scratch-path /workspace/build \
    --disable-dependency-cache \
    --manifest-cache local \
    --configuration release \
    --static-swift-stdlib \
    --jobs $(nproc --all)

# Switch to the staging area.
WORKDIR /workspace/staging

# Copy main executable to staging area.
RUN --mount=type=cache,target=/workspace/build \
    cp "$(swift build --package-path /workspace/src --scratch-path /workspace/build -c release --show-bin-path)/miniBlog" ./

# Copy resources bundled by SPM to staging area.
RUN --mount=type=cache,target=/workspace/build \
    find -L "$(swift build --package-path /workspace/src --scratch-path /workspace/build -c release --show-bin-path)/" -regex '.*\.resources$' -exec cp -Ra {} ./ \;

# ================================
# Run image
# ================================
FROM ubuntu:jammy

# Make sure all system packages are up to date, and install only essential packages.
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get -q install -y \
      ca-certificates \
      tzdata \
# If your app or its dependencies import FoundationNetworking, also install `libcurl4`.
      libcurl4 \
# If your app or its dependencies import FoundationXML, also install `libxml2`.
      # libxml2 \
    && rm -r /var/lib/apt/lists/*

# Create the miniblog user and group with /app as its home directory.
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app miniblog

# Switch to the new home directory
WORKDIR /app

# Copy built executable and any staged resources from builder.
COPY --from=build --chown=miniblog:miniblog /workspace/staging /app
COPY --chown=miniblog:miniblog ./HTTPRoot ./HTTPRoot

# Ensure all further commands run as the miniblog user.
USER miniblog:miniblog

# Let Docker bind to port 8080.
EXPOSE 8080

# Start miniblog when the image is run, default to listening on 8080 in production environment.
ENTRYPOINT ["./miniBlog"]
CMD ["serve", "--log-level", "info", "--http-root", "/app/HTTPRoot", "--port", "8080", "--environment", "production"]
