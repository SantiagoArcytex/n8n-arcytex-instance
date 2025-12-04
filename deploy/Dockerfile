FROM n8nio/n8n:latest

# Set working directory
WORKDIR /home/node

# Create directory for n8n data
RUN mkdir -p /home/node/.n8n/files

# Set proper permissions
RUN chown -R node:node /home/node/.n8n

# Expose n8n port
EXPOSE 5678

# Use the default n8n entrypoint
USER node

