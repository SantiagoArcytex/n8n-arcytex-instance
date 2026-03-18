#!/bin/sh
# Fix ownership of the mounted volume, then drop to node user and start n8n
chown -R node:node /home/node/.n8n
exec su-exec node n8n start
