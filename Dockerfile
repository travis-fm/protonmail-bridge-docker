FROM golang:alpine AS build

RUN <<EOF
    apk add --no-cache \
        bash \
        build-base \
        libcbor-dev \
        libfido2-dev \
        libsecret-dev \
        make \
        pkgconf \
EOF

WORKDIR /build/
COPY proton-bridge/ /build/
RUN make build-nogui vault-editor

FROM alpine
LABEL maintainer="travis-fm <git@travis.fm>"

EXPOSE 25/tcp
EXPOSE 143/tcp

# Install dependencies and protonmail bridge
RUN <<EOF
    apk add --no-cache \
        ca-certificates \
        gpg-agent \
        libcbor \
        libfido2 \
        libsecret \
        pass \
        socat
EOF

# Copy bash scripts
COPY gpgparams entrypoint.sh /protonmail/

# Copy protonmail
COPY --from=build /build/bridge /protonmail/
COPY --from=build /build/proton-bridge /protonmail/
COPY --from=build /build/vault-editor /protonmail/

VOLUME /root
ENTRYPOINT ["bash", "/protonmail/entrypoint.sh"]
