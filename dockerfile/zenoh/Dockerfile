FROM --platform=$BUILDPLATFORM eclipse/zenoh:1.4.0

# Determine target architecture
ARG TARGETARCH
ENV TARGETARCH=${TARGETARCH}

# Set plugin version
ENV PLUGIN_VERSION=1.4.0

# Define download URL pattern based on arch
RUN if [ "$TARGETARCH" = "amd64" ]; then \
      ARCH_SUFFIX="x86_64-unknown-linux-musl"; \
    elif [ "$TARGETARCH" = "arm64" ]; then \
      ARCH_SUFFIX="aarch64-unknown-linux-musl"; \
    else \
      echo "Unsupported architecture: $TARGETARCH" && exit 1; \
    fi && \
    wget https://github.com/eclipse-zenoh/zenoh-plugin-mqtt/releases/download/${PLUGIN_VERSION}/zenoh-plugin-mqtt-${PLUGIN_VERSION}-${ARCH_SUFFIX}-standalone.zip -O plugin.zip && \
    unzip plugin.zip && \
    rm plugin.zip

# Optional DDS plugin support
# RUN if [ "$TARGETARCH" = "amd64" ]; then \
#       ARCH_SUFFIX="x86_64-unknown-linux-musl"; \
#     elif [ "$TARGETARCH" = "arm64" ]; then \
#       ARCH_SUFFIX="aarch64-unknown-linux-musl"; \
#     fi && \
#     wget https://github.com/eclipse-zenoh/zenoh-plugin-dds/releases/download/${PLUGIN_VERSION}/zenoh-plugin-dds-${PLUGIN_VERSION}-${ARCH_SUFFIX}-standalone.zip -O plugin.zip && \
#     unzip plugin.zip && \
#     rm plugin.zip

RUN apk add --no-cache netcat-openbsd

ENV RUST_LOG=debug

COPY router_config.json router_config.json
COPY client_config.json client_config.json
