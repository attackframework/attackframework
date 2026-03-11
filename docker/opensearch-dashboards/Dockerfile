# OpenSearch Dashboards with config substitution from .env (envsubst)
ARG OPENSEARCH_VERSION=2.18.0
FROM opensearchproject/opensearch-dashboards:${OPENSEARCH_VERSION}

# envsubst for substituting .env values into opensearch_dashboards.yml at container start
USER root
RUN (command -v dnf >/dev/null && dnf install -y gettext && dnf clean all) || (command -v yum >/dev/null && yum install -y gettext && yum clean all) || (command -v apt-get >/dev/null && apt-get update -y && apt-get install -y --no-install-recommends gettext-base && rm -rf /var/lib/apt/lists/*) || true
USER opensearch-dashboards

COPY --chown=opensearch-dashboards:opensearch-dashboards --chmod=755 entrypoint-wrapper.sh /usr/share/opensearch-dashboards/entrypoint-wrapper.sh
RUN sed -i 's/\r$//' /usr/share/opensearch-dashboards/entrypoint-wrapper.sh

ENTRYPOINT ["/usr/share/opensearch-dashboards/entrypoint-wrapper.sh"]
CMD ["opensearch-dashboards"]
