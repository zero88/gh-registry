ARG BASE_IMAGE_VERSION
FROM registry:$BASE_IMAGE_VERSION

RUN addgroup --system --gid 121 github \
    && adduser --system -G github --uid 1001 runner \
    && mkdir -p /var/lib/registry \
    && chown -R runner:github /var/lib/registry \
    && chmod -R 777 /var/lib/registry

# COPY ./config.yml /etc/docker/registry/config.yml
# VOLUME /tmp/registry

USER runner:github
