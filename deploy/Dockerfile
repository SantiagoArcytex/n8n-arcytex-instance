FROM n8nio/n8n:1.82.1

USER root

RUN mkdir -p /home/node/.n8n/files && chown -R node:node /home/node/.n8n

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:5678/healthz || exit 1

# Custom entrypoint to fix volume permissions before starting n8n
COPY --chmod=755 deploy/docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
