# Quick Start Deployment Checklist

Use this checklist for a fast deployment to Railway.app (recommended for free/low-cost).

## Pre-Deployment (5 minutes)

- [ ] Generate encryption key: `openssl rand -base64 32` (save this!)
- [ ] Choose a strong admin password
- [ ] Have your OpenAI API key ready (if using workflows)
- [ ] Have SMTP credentials ready (if using email features)

## Railway.app Deployment (10 minutes)

1. **Sign up/Login**
   - [ ] Go to [railway.app](https://railway.app)
   - [ ] Sign in with GitHub

2. **Create Project**
   - [ ] Click "New Project"
   - [ ] Select "Deploy from GitHub repo"
   - [ ] Choose this repository

3. **Configure Environment Variables**
   - [ ] Go to "Variables" tab
   - [ ] Add these variables:

   ```
   N8N_BASIC_AUTH_ACTIVE=true
   N8N_BASIC_AUTH_USER=admin
   N8N_BASIC_AUTH_PASSWORD=<your-strong-password>
   N8N_ENCRYPTION_KEY=<your-generated-key>
   N8N_PROTOCOL=https
   N8N_PORT=5678
   DB_TYPE=sqlite
   N8N_SECURE_COOKIE=true
   ```

4. **Add Persistent Volume**
   - [ ] Go to "Volumes" tab
   - [ ] Click "Add Volume"
   - [ ] Mount path: `/home/node/.n8n`

5. **Deploy**
   - [ ] Wait for build to complete (2-5 minutes)
   - [ ] Railway will provide a URL like: `https://your-app.up.railway.app`

6. **Set Webhook URL**
   - [ ] Go back to "Variables"
   - [ ] Add:
     ```
     WEBHOOK_URL=https://your-app.up.railway.app
     N8N_HOST=your-app.up.railway.app
     ```
   - [ ] Redeploy if needed

## Post-Deployment (15 minutes)

1. **Access n8n**
   - [ ] Visit your Railway URL
   - [ ] Login with admin credentials

2. **Import Workflows**
   - [ ] Import `form-scoping/workflow.json`
   - [ ] Import `call-scoping/workflow.json`

3. **Update Call-Scoping Workflow**
   - [ ] Open call-scoping workflow
   - [ ] Edit "Read Scoping Guidelines" node
   - [ ] Change path to: `/home/node/.n8n/files/call-scoping-guidelines.txt`

4. **Configure Credentials**
   - [ ] Add OpenAI API credential (name: "OpenAI API")
   - [ ] Add SMTP credential (name: "SMTP")
   - [ ] Add Google Drive OAuth2 credential (name: "Google Drive account")

5. **Set Environment Variables in n8n**
   - [ ] Go to Settings → Environment Variables
   - [ ] Add: `TEAM_EMAIL=team@yourcompany.com`

6. **Activate Webhooks**
   - [ ] Open each workflow
   - [ ] Click "Execute Node" on Webhook node
   - [ ] Copy webhook URLs

7. **Test**
   - [ ] Send test webhook to form-scoping
   - [ ] Send test webhook to call-scoping
   - [ ] Verify emails and Google Docs are created

## Done! 🎉

Your n8n instance is now live and ready to use.

**Cost**: Free tier usually sufficient for 1-5 users (~$0-5/month)

**Next Steps**:
- Configure webhooks in GoHighLevel/Fathom
- Set up monitoring
- Review [full deployment guide](README.md) for advanced configuration

