# OpenSearch with transport-reactor-netty4 (HTTP/2 + HTTPS) and cert generation
ARG OPENSEARCH_VERSION=2.18.0
FROM opensearchproject/opensearch:${OPENSEARCH_VERSION}

# envsubst + openssl for config rendering and cert generation
USER root
RUN (command -v dnf >/dev/null && dnf install -y gettext openssl && dnf clean all) || (command -v yum >/dev/null && yum install -y gettext openssl && yum clean all) || (command -v apt-get >/dev/null && apt-get update -y && apt-get install -y --no-install-recommends gettext-base openssl && rm -rf /var/lib/apt/lists/*) || true
USER opensearch

# Install reactor-netty4 plugin for HTTP/2 over HTTPS
RUN /usr/share/opensearch/bin/opensearch-plugin install --batch transport-reactor-netty4

# Scripts: cert generation and entrypoint wrapper
COPY --chown=opensearch:opensearch --chmod=755 scripts/generate-certs.sh /usr/share/opensearch/scripts/generate-certs.sh
COPY --chown=opensearch:opensearch --chmod=755 entrypoint-wrapper.sh /usr/share/opensearch/entrypoint-wrapper.sh
RUN sed -i 's/\r$//' /usr/share/opensearch/scripts/generate-certs.sh /usr/share/opensearch/entrypoint-wrapper.sh

ENTRYPOINT ["/usr/share/opensearch/entrypoint-wrapper.sh"]
CMD ["opensearch"]
