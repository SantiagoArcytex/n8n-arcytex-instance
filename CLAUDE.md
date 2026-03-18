# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

n8n Automation Playground for generating project scope summaries from business data. Two main workflows:
- **Form-Scoping**: Generates scopes from GoHighLevel form submissions
- **Call-Scoping**: Generates scopes from Fathom call transcripts

Both workflows follow the same pipeline: webhook input → OpenAI LLM analysis → Google Docs creation → Google Drive organization (`Client Scoping/[Company Name]/[Client Name]/`) → email notifications.

## Common Commands

```bash
# Local development
cp deploy/env.example .env        # First-time setup
openssl rand -base64 32           # Generate N8N_ENCRYPTION_KEY
docker-compose up -d              # Start n8n at http://localhost:5678
docker-compose down               # Stop

# Deployment (Railway.app recommended)
# Push to Git → Railway auto-deploys from deploy/Dockerfile
```

## Architecture

```
├── docker-compose.yml        # Local dev (n8n + SQLite on :5678)
├── railway.json              # Points Railway to deploy/Dockerfile
├── deploy/                   # Production deployment configs (committed)
│   ├── Dockerfile            # Minimal: official n8n image + /files dir
│   ├── env.example           # All environment variables (~50 vars)
│   ├── railway.json, fly.toml, render.yaml  # Multi-platform configs
│   └── README.md, QUICKSTART.md             # Deployment guides
├── form-scoping/             # Form workflow (LOCAL ONLY - gitignored)
│   ├── workflow.json         # n8n workflow definition
│   └── scoping-guidelines.txt
└── call-scoping/             # Call workflow (LOCAL ONLY - gitignored)
    ├── workflow.json
    └── scoping-guidelines.txt
```

**Key convention**: Workflow folders (`form-scoping/`, `call-scoping/`) are gitignored — only `deploy/` is committed. Workflows are managed through the n8n UI, not version control.

## Environment & Infrastructure

- **Local**: SQLite database, basic auth
- **Production**: PostgreSQL, n8n user management with 2FA, HTTPS
- **Critical env vars**: `N8N_ENCRYPTION_KEY`, `WEBHOOK_URL`, `N8N_PROTOCOL`
- **Health check**: `GET /healthz`
- **Data persistence**: Volume at `/home/node/.n8n`

## Required External Credentials (configured in n8n UI)

- OpenAI API (scope generation)
- Google Drive OAuth2 (document creation/sharing)
- SMTP provider (email notifications)
