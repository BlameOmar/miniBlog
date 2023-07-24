FROM swift:5.8-jammy as prepare

ARG swiftpm_cache=/root/.cache/org.swift.swiftpm

WORKDIR /workspace/src

COPY ./Package.* ./
RUN --mount=type=cache,target=$swiftpm_cache \
    swift package resolve --only-use-versions-from-resolved-file --skip-update

COPY ./Sources ./Sources
COPY ./Tests ./Tests


FROM prepare as build-debug

RUN swift build --only-use-versions-from-resolved-file --skip-update --build-tests --jobs $(nproc --all)


FROM prepare as build-release

RUN swift build \
    --only-use-versions-from-resolved-file  \
    --skip-update \
    --configuration release \
    --static-swift-stdlib \
    --jobs $(nproc --all)


FROM build-release as staging

WORKDIR /workspace/staging

# Copy main executable to staging area.
RUN cp /workspace/src/.build/release/miniBlog ./

# Copy resources bundled by SPM to staging area.
RUN find -L /workspace/src/.build/release/ -regex '.*\.resources$' -exec cp -Ra {} ./ \;


FROM build-debug as app-debug

COPY ./HTTPRoot ./HTTPRoot


FROM swift:5.8-jammy-slim as app

# Create the miniblog user and group with /app as its home directory.
RUN useradd --user-group --create-home --system --skel /dev/null --home-dir /app miniblog

# Switch to the new home directory
WORKDIR /app

# Copy built executable and any staged resources from builder.
COPY --from=staging --chown=miniblog:miniblog /workspace/staging /app
COPY --chown=miniblog:miniblog ./HTTPRoot ./HTTPRoot

# Ensure all further commands run as the miniblog user.
USER miniblog:miniblog

# Let Docker bind to port 8080.
EXPOSE 8080

# Start miniblog when the image is run, default to listening on 8080 in production environment.
ENTRYPOINT ["./miniBlog"]
CMD ["serve", "--log-level", "info", "--http-root", "/app/HTTPRoot", "--port", "8080", "--environment", "production"]
