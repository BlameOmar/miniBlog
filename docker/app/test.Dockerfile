FROM swift:5.8-jammy as test

RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y\
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace/src

COPY ./Package.* ./

RUN swift package resolve --only-use-versions-from-resolved-file --skip-update

COPY ./Sources ./Sources
COPY ./Tests ./Tests

RUN swift build --only-use-versions-from-resolved-file --skip-update --build-tests --jobs $(nproc --all)

ENTRYPOINT ["/usr/bin/swift", "test", "--only-use-versions-from-resolved-file", "--skip-update", "--parallel"]
