FROM n8nio/n8n:1.82.1

WORKDIR /home/node

RUN mkdir -p /home/node/.n8n/files

EXPOSE 5678

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:5678/healthz || exit 1

# Custom entrypoint to fix volume permissions before starting n8n
COPY deploy/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
