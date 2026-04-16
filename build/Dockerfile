# The build image could be golang, but it currently does not support riscv64. Only debian:sid does, at the time of writing.
FROM debian:trixie-slim AS build

ARG version

# Install dependencies
RUN <<EOF
    apt-get update
    apt-get install -y \
        build-essential \
        golang \
        libcbor-dev \
        libfido2-dev \
        libsecret-1-dev \
        pkg-config \
EOF

# Build
ADD https://github.com/ProtonMail/proton-bridge.git#${version} /build/
WORKDIR /build/
RUN make build-nogui vault-editor

FROM debian:trixie-slim
LABEL maintainer="travis-fm <git@travis.fm>"

EXPOSE 25/tcp
EXPOSE 143/tcp

# Install dependencies and protonmail bridge
RUN <<EOF
    apt-get update
    apt-get install -y --no-install-recommends \
        ca-certificates \
        libcbor0.10 \
        libfido2-1 \
        libsecret-1-0 \
        pass \
        socat
    rm -rf /var/lib/apt/lists/*
EOF

# Copy bash scripts
COPY gpgparams entrypoint.sh /protonmail/

# Copy protonmail
COPY --from=build /build/bridge /protonmail/
COPY --from=build /build/proton-bridge /protonmail/
COPY --from=build /build/vault-editor /protonmail/

ENTRYPOINT ["bash", "/protonmail/entrypoint.sh"]
