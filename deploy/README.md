# n8n Deployment Guide

This guide will help you deploy your n8n instance to a container platform (Railway.app, Fly.io, or Render.com) with authentication, persistent storage, and all necessary configurations.

## Prerequisites

- GitHub account (for Railway.app deployment)
- Account on your chosen platform (Railway.app, Fly.io, or Render.com)
- Basic understanding of environment variables

## Platform Comparison

| Platform | Free Tier | Persistent Storage | Always On | Best For |
|----------|-----------|-------------------|-----------|----------|
| **Railway.app** | $20/month recommended | ✅ Yes | ✅ Yes | **Recommended** - Multi-user setup, PostgreSQL support |
| **Fly.io** | Free tier | ✅ Yes | ✅ Yes | Good alternative |
| **Render.com** | Free tier | ✅ Yes | ❌ Sleeps after inactivity | Budget option |

## Multi-User Setup on Railway.app (Recommended)

This guide focuses on deploying n8n Community Edition with **multi-user support** (1-20 users) and **2FA** on Railway's $20/month tier. The Community Edition supports unlimited users and workspaces without requiring n8n paid licenses.

### Key Features Enabled:
- ✅ Individual user accounts (no shared credentials)
- ✅ Two-factor authentication (2FA) per user
- ✅ Unlimited users and workspaces (Community Edition)
- ✅ PostgreSQL database for better multi-user performance
- ✅ SMTP email for user invitations

## Quick Start: Railway.app Multi-User Deployment

### Step 1: Prepare Your Repository

1. **Initialize Git Repository** (if not already done):
   ```bash
   cd /Users/santiagojuarez/dev/arcytex/n8n-playground
   git init
   ```

2. **Ensure deployment files are committed**:
   ```bash
   # Add deployment files (workflow folders are excluded via .gitignore)
   git add deploy/ .gitignore docker-compose.yml README.md
   git commit -m "Add n8n deployment configuration for Railway"
   ```

3. **Create GitHub Repository** (if not already created):
   - Go to GitHub and create a new repository
   - Don't initialize with README (you already have one)

4. **Connect and Push**:
   ```bash
   git remote add origin https://github.com/yourusername/your-repo-name.git
   git branch -M main
   git push -u origin main
   ```

**Note:** The `form-scoping/` and `call-scoping/` folders are excluded from Git (see `.gitignore`). Only the deployment configuration in `deploy/` will be pushed to GitHub.

### Step 2: Deploy on Railway.app

1. **Sign up/Login**: Go to [railway.app](https://railway.app) and sign in with GitHub

2. **Create New Project**:
   - Click "New Project"
   - Select "Deploy from GitHub repo"
   - Choose your repository
   - **Important:** Railway will deploy from the root. You need to configure it to use the `deploy/` folder (see next step)

3. **Add PostgreSQL Service** (Required for Multi-User):
   - In your Railway project, click "+ New"
   - Select "Database" → "Add PostgreSQL"
   - Railway will automatically create a PostgreSQL instance
   - Note: Railway provides connection variables automatically

4. **Configure n8n Service**:
   - Railway will auto-detect a Dockerfile, but it's in the `deploy/` folder
   - Click on the n8n service to configure it
   - Go to "Settings" tab
   - Under "Build & Deploy", set:
     - **Root Directory:** `deploy`
     - This tells Railway to look for the Dockerfile in the `deploy/` folder

5. **Set Environment Variables**:
   - Go to "Variables" tab in the n8n service
   - Add the following required variables:

   ```bash
   # Disable basic auth (enables multi-user mode)
   N8N_BASIC_AUTH_ACTIVE=false
   
   # Webhook Configuration
   N8N_PROTOCOL=https
   N8N_PORT=5678
   
   # Encryption Key (generate with: openssl rand -base64 32)
   N8N_ENCRYPTION_KEY=<generate-a-random-key>
   
   # PostgreSQL Database (Railway provides these automatically)
   DB_TYPE=postgresdb
   DB_POSTGRESDB_HOST=${{Postgres.PGHOST}}
   DB_POSTGRESDB_PORT=${{Postgres.PGPORT}}
   DB_POSTGRESDB_DATABASE=${{Postgres.PGDATABASE}}
   DB_POSTGRESDB_USER=${{Postgres.PGUSER}}
   DB_POSTGRESDB_PASSWORD=${{Postgres.PGPASSWORD}}
   
   # Security
   N8N_SECURE_COOKIE=true
   
   # Multi-User & 2FA
   N8N_MFA_ENABLED=true
   
   # SMTP Configuration (REQUIRED for user invitations)
   N8N_EMAIL_MODE=smtp
   N8N_SMTP_HOST=smtp.gmail.com
   N8N_SMTP_PORT=587
   N8N_SMTP_USER=your-email@gmail.com
   N8N_SMTP_PASS=your-app-password
   N8N_SMTP_SECURE=false
   ```

6. **Generate Encryption Key**:
   ```bash
   openssl rand -base64 32
   ```
   Copy the output and set it as `N8N_ENCRYPTION_KEY`

7. **Configure SMTP** (Required for User Invitations):
   
   **Option A: Gmail (Recommended for MVP)**
   - Go to your Google Account → Security → 2-Step Verification
   - Generate an App Password for "Mail"
   - Use your Gmail address for `N8N_SMTP_USER`
   - Use the generated App Password for `N8N_SMTP_PASS`
   - Set `N8N_SMTP_HOST=smtp.gmail.com` and `N8N_SMTP_PORT=587`
   
   **Option B: SendGrid**
   - Sign up at [sendgrid.com](https://sendgrid.com)
   - Create an API key
   - Use `smtp.sendgrid.net` as host, port `587`
   - Username: `apikey`, Password: your API key
   
   **Option C: AWS SES**
   - Configure AWS SES SMTP credentials
   - Use your SES SMTP endpoint (e.g., `email-smtp.us-east-1.amazonaws.com`)

8. **Set Webhook URL** (after deployment):
   - Railway will provide a URL like: `https://your-app-name.up.railway.app`
   - Go to "Variables" and set:
     ```
     WEBHOOK_URL=https://your-app-name.up.railway.app
     N8N_HOST=your-app-name.up.railway.app
     ```

9. **Add Persistent Volume**:
   - Go to "Volumes" tab
   - Click "Add Volume"
   - Mount path: `/home/node/.n8n`
   - This stores workflows, credentials, and execution data

10. **Deploy**:
    - Railway will automatically build and deploy
    - Wait for deployment to complete (2-5 minutes)

11. **Access Your Instance**:
    - Click on the service
    - Click "Generate Domain" if not already done
    - Visit the URL - you'll be prompted to create the **Owner account** (first admin user)

## Alternative: Fly.io Deployment

### Step 1: Install Fly CLI

```bash
# macOS
brew install flyctl

# Linux/Windows
curl -L https://fly.io/install.sh | sh
```

### Step 2: Login and Create App

```bash
fly auth login
fly launch
```

### Step 3: Configure fly.toml

Create `fly.toml`:

```toml
app = "your-app-name"
primary_region = "iad"

[build]
  dockerfile = "Dockerfile"

[env]
  N8N_BASIC_AUTH_ACTIVE = "true"
  N8N_BASIC_AUTH_USER = "admin"
  N8N_BASIC_AUTH_PASSWORD = "<your-password>"
  N8N_ENCRYPTION_KEY = "<your-encryption-key>"
  DB_TYPE = "sqlite"
  N8N_PROTOCOL = "https"
  N8N_SECURE_COOKIE = "true"

[[services]]
  internal_port = 5678
  protocol = "tcp"

  [[services.ports]]
    handlers = ["http"]
    port = 80
    force_https = true

  [[services.ports]]
    handlers = ["tls", "http"]
    port = 443

  [services.concurrency]
    hard_limit = 25
    soft_limit = 20

[[mounts]]
  source = "n8n_data"
  destination = "/home/node/.n8n"
```

### Step 4: Create Volume and Deploy

```bash
# Create persistent volume
fly volumes create n8n_data --size 3

# Deploy
fly deploy

# Set secrets (environment variables)
fly secrets set N8N_BASIC_AUTH_PASSWORD=<your-password>
fly secrets set N8N_ENCRYPTION_KEY=<your-encryption-key>
```

## Alternative: Render.com Deployment

### Step 1: Create Web Service

1. Go to [render.com](https://render.com) and sign in
2. Click "New +" → "Web Service"
3. Connect your GitHub repository

### Step 2: Configure Service

- **Name**: Your app name
- **Environment**: Docker
- **Dockerfile Path**: `Dockerfile`
- **Docker Context**: `.` (root)

### Step 3: Add Environment Variables

Add all variables from `.env.example` in the Render dashboard.

### Step 4: Add Persistent Disk

1. Go to "Disks" tab
2. Click "Add Disk"
3. Name: `n8n_data`
4. Mount Path: `/home/node/.n8n`
5. Size: 1GB (minimum)

### Step 5: Deploy

- Render will build and deploy automatically
- Note: Free tier sleeps after 15 minutes of inactivity

## Post-Deployment Setup

### 1. Create Owner Account (First User)

- Visit your deployed n8n URL
- You'll be prompted to create the **Owner account** (first admin user)
- Enter your email, name, and password
- This account has full administrative privileges

### 2. Invite Additional Users

1. **Navigate to User Management**:
   - Click on your profile (top right) → "Settings"
   - Go to "Users" in the left sidebar

2. **Invite Users**:
   - Click "Invite" button
   - Enter the email address of the team member
   - Select role: "Member" (or "Owner" for admin access)
   - Click "Send Invitation"
   - The user will receive an email invitation (requires SMTP to be configured)

3. **User Accepts Invitation**:
   - User clicks the invitation link in their email
   - They'll be prompted to set up their account (name, password)
   - Once set up, they can log in with their credentials

### 3. Enable Two-Factor Authentication (2FA)

Each user can enable 2FA individually:

1. **User logs in** to their n8n account
2. **Navigate to Settings**:
   - Click profile (top right) → "Settings"
   - Go to "Personal" in the left sidebar
3. **Enable 2FA**:
   - Scroll to "Two-Factor Authentication" section
   - Click "Enable 2FA"
   - Scan the QR code with an authenticator app (Google Authenticator, Authy, etc.)
   - Enter the 6-digit code from your authenticator app
   - Click "Verify and Enable"
4. **Save Backup Codes**:
   - n8n will provide backup codes - save these securely
   - Use backup codes if you lose access to your authenticator

**Note**: 2FA is per-user and optional. Each user must enable it individually.

### 4. Import Workflows

1. Go to "Workflows" → "Import from File"
2. Import `form-scoping/workflow.json`
3. Import `call-scoping/workflow.json`

### 5. Configure Scoping Guidelines Files

The Dockerfile automatically copies the scoping guidelines files:

- **Form-scoping workflow**: Uses `/scoping-guidelines.txt` (already configured, works out of the box)
- **Call-scoping workflow**: Currently references `/scoping-guidelines.txt`, but needs to be updated

**For call-scoping workflow:**
1. Open the `call-scoping` workflow in n8n
2. Click on the "Read Scoping Guidelines" node
3. Update the file path from `/scoping-guidelines.txt` to `/home/node/.n8n/files/call-scoping-guidelines.txt`
4. Save the workflow

**Alternative:** If you want both workflows to use the same guidelines file, you can leave them as-is (both will use the form-scoping guidelines).

### 6. Configure Credentials

Set up the following credentials in n8n:

**OpenAI API Credentials:**
1. Go to "Credentials" → "Add Credential" → "OpenAI API"
2. Enter your OpenAI API key
3. Name it "OpenAI API"

**SMTP Email Credentials:**
1. Go to "Credentials" → "Add Credential" → "SMTP"
2. Enter your SMTP settings:
   - Host: `smtp.gmail.com` (or your SMTP server)
   - Port: `587`
   - User: Your email
   - Password: Your app-specific password
   - Secure: `false` (for TLS)
3. Name it "SMTP"

**Google Drive OAuth2 Credentials:**
1. Go to "Credentials" → "Add Credential" → "Google Drive OAuth2 API"
2. Follow the OAuth2 flow to authorize
3. Name it "Google Drive account"

### 7. Configure Environment Variables in n8n

1. Go to "Settings" → "Environment Variables"
2. Add:
   ```
   TEAM_EMAIL=team@yourcompany.com
   ```

### 8. Activate Webhooks

1. Open each workflow
2. Click on the "Webhook" node
3. Click "Execute Node" to activate
4. Copy the webhook URL (will be: `https://your-instance.com/webhook/...`)

### 9. Test Your Workflows

- Test the form-scoping workflow by sending a POST request to the webhook
- Test the call-scoping workflow similarly
- Verify emails are sent and Google Docs are created

## Troubleshooting

### Issue: Cannot invite users / Invitation emails not sending

**Solution**: 
- Verify SMTP configuration is correct in Railway environment variables
- Test SMTP credentials (check Gmail App Password, SendGrid API key, etc.)
- Check Railway logs for SMTP connection errors
- Ensure `N8N_EMAIL_MODE=smtp` is set

### Issue: Users cannot log in after invitation

**Solution**:
- Verify the invitation link hasn't expired
- Check that user is using the correct email address
- Ensure user completes account setup (password creation) from invitation link

### Issue: 2FA not working

**Solution**:
- Verify `N8N_MFA_ENABLED=true` is set in environment variables
- Ensure user has completed 2FA setup (scanned QR code and verified)
- Check that authenticator app time is synchronized
- Use backup codes if authenticator is lost

### Issue: Webhooks not working

**Solution**: Ensure `WEBHOOK_URL` and `N8N_HOST` are set correctly in environment variables.

### Issue: Database connection errors

**Solution**: 
- Verify PostgreSQL service is running in Railway
- Check that PostgreSQL environment variables are correctly referenced (`${{Postgres.PGHOST}}`, etc.)
- Ensure PostgreSQL service is in the same Railway project

### Issue: Files not found

**Solution**: 
- Verify scoping guidelines files are in the correct location
- Update workflow file paths if needed
- Check file permissions

### Issue: Credentials not saving

**Solution**: 
- Ensure `N8N_ENCRYPTION_KEY` is set
- Verify persistent volume is mounted correctly

### Issue: Instance sleeping (Render.com)

**Solution**: 
- Upgrade to paid plan for always-on
- Or use Railway.app/Fly.io which don't sleep

### Issue: Out of memory

**Solution**: 
- Upgrade to Railway's $20 tier or higher for more resources
- Reduce execution data retention settings

## Cost Optimization Tips

1. **Railway.app $20 Tier**: Recommended for 1-20 users with PostgreSQL and persistent storage
2. **Execution Data**: Set `EXECUTIONS_DATA_SAVE_ON_SUCCESS=none` to save storage
3. **Database**: PostgreSQL is recommended for multi-user setups (better performance and reliability)
4. **Cleanup**: Regularly clean old execution data in n8n settings
5. **SMTP**: Use Gmail (free) or SendGrid free tier (100 emails/day) for user invitations

## Security Best Practices

1. **Disable Basic Auth**: Set `N8N_BASIC_AUTH_ACTIVE=false` for multi-user setup (uses n8n's built-in auth)
2. **Strong Encryption Key**: Use a strong, randomly generated `N8N_ENCRYPTION_KEY`
3. **HTTPS Only**: Ensure `N8N_PROTOCOL=https` and `N8N_SECURE_COOKIE=true` in production
4. **Enable 2FA**: Encourage all users to enable 2FA in their personal settings
5. **Strong Passwords**: Enforce strong password policies for user accounts
6. **Regular Updates**: Keep n8n updated by rebuilding the Docker image
7. **Backup**: Regularly backup the persistent volume and PostgreSQL database (workflows and credentials)
8. **SMTP Security**: Use App Passwords or API keys for SMTP, never use your main account password

## Backup and Recovery

### Backup Workflows

1. Export workflows from n8n UI (Workflows → Export)
2. Or backup the entire `/home/node/.n8n` volume

### Restore

1. Import workflows via n8n UI
2. Or restore the volume from backup

## Support

- n8n Documentation: https://docs.n8n.io
- Railway.app Docs: https://docs.railway.app
- Fly.io Docs: https://fly.io/docs
- Render.com Docs: https://render.com/docs

