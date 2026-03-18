FROM n8nio/n8n:1.82.1

# Set working directory
WORKDIR /home/node

# Create directory for n8n data
RUN mkdir -p /home/node/.n8n/files

# Set proper permissions
RUN chown -R node:node /home/node/.n8n

# Expose n8n port
EXPOSE 5678

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
  CMD wget --quiet --tries=1 --spider http://localhost:5678/healthz || exit 1

# Use the default n8n entrypoint
USER node

