# Quick Start Guide

Get your IT HelpDesk Declarative Agent up and running in 15 minutes!

## Prerequisites

Before you begin, ensure you have:
- [ ] Microsoft 365 subscription with Copilot license
- [ ] ServiceNow instance and credentials
- [ ] Access to Teams Admin Center or Copilot Studio
- [ ] SharePoint or OneDrive for Business access

## Step 1: Configure ServiceNow (5 minutes)

### Update ServiceNow URL
Edit `appPackage/servicenow-openapi.json`:

```json
"servers": [
  {
    "url": "https://YOUR-INSTANCE.service-now.com/api/now"
  }
]
```

Replace `YOUR-INSTANCE` with your actual ServiceNow instance name.

### Test ServiceNow API
```bash
curl -X GET "https://YOUR-INSTANCE.service-now.com/api/now/table/incident?sysparm_limit=1" \
  -H "Accept: application/json" \
  -u "username:password"
```

If you get JSON data back, you're good to go! ✓

## Step 2: Set Up Knowledge Base (3 minutes)

### Upload FAQ
1. Open SharePoint or OneDrive for Business
2. Upload `knowledge/it-helpdesk-faq.md`
3. Right-click → "Copy link" → Select "People in organization can view"

### Update Agent Configuration
Edit `appPackage/declarativeAgent.json`:

```json
"capabilities": [
  {
    "name": "OneDriveAndSharePoint",
    "items_by_url": [
      {
        "url": "PASTE-YOUR-SHAREPOINT-URL-HERE"
      }
    ]
  }
]
```

## Step 3: Add App Icons (2 minutes)

### Create or Copy Icons
You need two PNG files in the `appPackage/` directory:

1. **color.png** - 192x192 pixels, full color
2. **outline.png** - 32x32 pixels, transparent background

**Quick option**: Use temporary placeholder images for testing:
- Download any 192x192 PNG and save as `color.png`
- Download any 32x32 PNG and save as `outline.png`

## Step 4: Create Package (1 minute)

### Run Packaging Script
```bash
chmod +x package.sh
./package.sh
```

This creates `ithelpdesk-agent.zip` ready for deployment.

## Step 5: Deploy to Microsoft 365 (5 minutes)

### Option A: Via Teams Admin Center

1. Go to [Teams Admin Center](https://admin.teams.microsoft.com)
2. Navigate to **Teams apps** → **Manage apps**
3. Click **Upload** → Upload `ithelpdesk-agent.zip`
4. Approve the app
5. Assign to users/groups

### Option B: Via Copilot Studio

1. Go to [Copilot Studio](https://copilotstudio.microsoft.com)
2. Click **Create** → **Declarative Agent**
3. Choose **Import** → Upload `ithelpdesk-agent.zip`
4. Test in the playground
5. Click **Publish**

## Step 6: Test Your Agent (2 minutes)

### Open Microsoft Teams
1. Open Microsoft Teams (desktop or web)
2. Go to **Apps** in the left sidebar
3. Search for "IT HelpDesk"
4. Click to open

### Try These Test Queries
```
"How do I reset my password?"
"Create a ticket for my printer issue"
"Show me my ServiceNow tickets"
```

## Verification Checklist

- [ ] ServiceNow API responds successfully
- [ ] Knowledge base file is accessible in SharePoint/OneDrive
- [ ] App icons are in place (color.png and outline.png)
- [ ] Package created without errors
- [ ] App uploaded to Teams or Copilot Studio
- [ ] Agent appears in Microsoft Teams
- [ ] Knowledge base queries work
- [ ] ServiceNow integration works (if configured)

## Common Quick Start Issues

### "Cannot find package.sh"
**Solution**: Make sure you're in the root directory of the repository.

### "ServiceNow API returns 401"
**Solution**: Check your ServiceNow credentials and ensure the account has proper permissions.

### "Knowledge base not loading"
**Solution**: Verify the SharePoint URL is correct and the file has proper sharing permissions.

### "App doesn't appear in Teams"
**Solution**: Wait a few minutes for propagation, or check Teams Admin Center for approval status.

## Next Steps

Once your agent is running:

1. **Customize Knowledge Base**: Edit `knowledge/it-helpdesk-faq.md` with your organization's specific content
2. **Update Instructions**: Modify `appPackage/instructions.md` for custom behavior
3. **Add Custom Icons**: Replace placeholder icons with branded icons
4. **Configure OAuth**: Set up OAuth 2.0 for ServiceNow (see CONFIGURATION.md)
5. **Train Users**: Share conversation starters and use cases
6. **Monitor Usage**: Track common queries and feedback

## Full Documentation

For detailed configuration and troubleshooting:
- **README.md** - Complete documentation
- **CONFIGURATION.md** - Detailed configuration guide

## Getting Help

Stuck? Here's what to do:
1. Review error messages carefully
2. Check the troubleshooting sections in README.md
3. Verify each step was completed
4. Test components individually (ServiceNow API, knowledge base, etc.)
5. Contact your Microsoft 365 or ServiceNow administrator

## Success! 🎉

If you can ask questions and get answers, your IT HelpDesk Agent is working!

**What users can do:**
- Get instant answers to common IT questions
- Create ServiceNow tickets conversationally
- Check ticket status
- Get step-by-step troubleshooting guides

**Example conversation:**
```
User: "My laptop is slow"
Agent: "I can help with that! Here are some quick fixes:
1. Restart your computer
2. Close unnecessary applications
3. Clear browser cache
...

Would you like me to create a ServiceNow ticket if these don't help?"
```

Enjoy your new IT HelpDesk Agent! 🚀
