# n8n Playground - Workflow Automation

This repository contains n8n workflows for automating project scoping processes, including form submissions and call transcript analysis.

## Workflows

### 1. Form Scoping (`form-scoping/`)
Automates project scope summary generation from GoHighLevel form submissions:
- Receives form data via webhook
- Generates comprehensive scope summaries using OpenAI
- Creates formatted Google Docs
- Sends email notifications

### 2. Call Scoping (`call-scoping/`)
Automates project scope summary generation from Fathom call transcripts:
- Receives call transcript/summary via webhook
- Analyzes conversation using OpenAI
- Generates scope summaries
- Creates Google Docs and sends notifications

## Quick Start

### Local Development

1. **Using Docker Compose** (Recommended):
   ```bash
   # Copy environment variables
   cp deploy/env.example .env
   # Edit .env with your values
   
   # Generate encryption key
   openssl rand -base64 32
   # Add to .env as N8N_ENCRYPTION_KEY
   
   # Start n8n
   docker-compose up -d
   
   # Access at http://localhost:5678
   ```

2. **Import Workflows**:
   - Open n8n at http://localhost:5678
   - Import `form-scoping/workflow.json`
   - Import `call-scoping/workflow.json`

3. **Configure Credentials**:
   - OpenAI API
   - SMTP (for email)
   - Google Drive OAuth2

## Deployment

For production deployment to a container platform, see the [Deployment Guide](deploy/README.md).

**Multi-User Setup (Recommended):**
- **Railway.app** ($20/month tier): Supports unlimited users and workspaces with individual accounts and 2FA
  - See [deploy/README.md](deploy/README.md#multi-user-setup-on-railwayapp-recommended) for complete setup guide
  - Requires PostgreSQL and SMTP configuration
  - Each user gets their own account with optional 2FA

**Quick Deploy Options:**
- **Railway.app**: $20/month tier recommended for multi-user - see [deploy/README.md](deploy/README.md#quick-start-railwayapp-multi-user-deployment)
- **Fly.io**: Free tier with persistent volumes
- **Render.com**: Free tier (sleeps after inactivity)

## Project Structure

```
.
├── form-scoping/          # Form-based scoping workflow (local only, not in Git)
│   ├── workflow.json     # n8n workflow definition
│   ├── scoping-guidelines.txt
│   ├── env.example       # Environment variables template
│   └── README.md         # Workflow-specific documentation
├── call-scoping/         # Call transcript scoping workflow (local only, not in Git)
│   ├── workflow.json     # n8n workflow definition
│   ├── scoping-guidelines.txt
│   ├── env.example       # Environment variables template
│   └── README.md         # Workflow-specific documentation
├── deploy/               # Deployment configuration and guides
│   ├── Dockerfile        # Docker configuration for n8n
│   ├── railway.json      # Railway.app configuration
│   ├── fly.toml          # Fly.io configuration
│   ├── render.yaml       # Render.com configuration
│   ├── env.example       # Deployment environment variables
│   └── README.md         # Complete deployment guide
├── docker-compose.yml    # Local development setup
├── .gitignore           # Git ignore rules (excludes workflow folders)
└── README.md            # This file
```

**Note:** The `form-scoping/` and `call-scoping/` folders are kept local only (excluded from Git via `.gitignore`). Only the deployment configuration in `deploy/` is committed to the repository.

## Requirements

- n8n instance (self-hosted or cloud)
- OpenAI API key
- SMTP email account (Gmail, SendGrid, AWS SES, etc.)
- Google Drive account with OAuth2 access
- GoHighLevel account (for form-scoping workflow)
- Fathom account (for call-scoping workflow)

## Multi-User & 2FA Support

This setup supports **unlimited users and workspaces** using n8n Community Edition (no paid licenses required).

### Features:
- ✅ **Individual user accounts** - Each team member has their own login credentials
- ✅ **Two-factor authentication (2FA)** - Users can enable 2FA individually in Settings > Personal
- ✅ **Unlimited users** - Community Edition supports unlimited users and workspaces
- ✅ **User invitations** - Invite users via email (requires SMTP configuration)

### Setup Requirements:
- PostgreSQL database (recommended for multi-user)
- SMTP configuration (required for sending user invitation emails)
- `N8N_BASIC_AUTH_ACTIVE=false` (disables basic auth, enables multi-user mode)
- `N8N_MFA_ENABLED=true` (enables 2FA support)

See the [Deployment Guide](deploy/README.md#multi-user-setup-on-railwayapp-recommended) for complete setup instructions.

## Environment Variables

See `deploy/env.example` for all required environment variables. Key variables:

### Multi-User Configuration:
- `N8N_BASIC_AUTH_ACTIVE`: Set to `false` for multi-user mode (uses n8n's built-in user management)
- `N8N_MFA_ENABLED`: Set to `true` to enable 2FA support
- `N8N_EMAIL_MODE`: Set to `smtp` for user invitations
- `N8N_SMTP_*`: SMTP configuration (required for user invitations)

### Database:
- `DB_TYPE`: Use `postgresdb` for multi-user (recommended) or `sqlite` for single-user
- `DB_POSTGRESDB_*`: PostgreSQL connection variables

### General:
- `N8N_ENCRYPTION_KEY`: Encryption key for credentials (generate with `openssl rand -base64 32`)
- `WEBHOOK_URL`: Your n8n instance URL
- `TEAM_EMAIL`: Team email for notifications

## Documentation

- [Form Scoping Workflow](form-scoping/README.md) - Detailed setup for form-based scoping
- [Call Scoping Workflow](call-scoping/README.md) - Detailed setup for call transcript scoping
- [Deployment Guide](deploy/README.md) - Complete deployment instructions for container platforms

## Support

- n8n Documentation: https://docs.n8n.io
- n8n Community: https://community.n8n.io

## License

[Add your license here]

