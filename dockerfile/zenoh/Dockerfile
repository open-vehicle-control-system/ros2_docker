FROM eclipse/zenoh:1.4.0

RUN wget https://github.com/eclipse-zenoh/zenoh-plugin-mqtt/releases/download/1.4.0/zenoh-plugin-mqtt-1.4.0-x86_64-unknown-linux-musl-standalone.zip -O plugin.zip && \
  unzip plugin.zip && \
  rm plugin.zip

# RUN wget https://github.com/eclipse-zenoh/zenoh-plugin-dds/releases/download/1.4.0/zenoh-plugin-dds-1.4.0-x86_64-unknown-linux-musl-standalone.zip -O plugin.zip && \
#   unzip plugin.zip && \
#   rm plugin.zip

ENV RUST_LOG=debug

COPY router_config.json5 router_config.json5
COPY router_config2.json5 router_config2.json5
