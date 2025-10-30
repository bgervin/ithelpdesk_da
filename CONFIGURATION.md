# Configuration Guide

This guide will help you configure the IT HelpDesk Declarative Agent for your environment.

## Required Configuration Steps

### 1. ServiceNow Instance Configuration

#### Update the OpenAPI Specification
File: `appPackage/servicenow-openapi.json`

**Replace the server URL:**
```json
"servers": [
  {
    "url": "https://YOUR-INSTANCE.service-now.com/api/now",
    "description": "ServiceNow Production Instance"
  }
]
```

**Example:**
- If your ServiceNow instance is `acme.service-now.com`, change to:
  ```json
  "url": "https://acme.service-now.com/api/now"
  ```

#### Configure Authentication
File: `appPackage/serviceNowPlugin.json`

The default configuration uses no authentication (for testing). For production:

**Option 1: Basic Authentication (Simple but less secure)**
```json
"auth": {
  "type": "none"
}
```
Note: With "none", authentication will be handled at the network level or through the manifest.

**Option 2: OAuth 2.0 (Recommended for Production)**
```json
"auth": {
  "type": "oauth2"
}
```

### 2. Knowledge Base Configuration

#### Upload the FAQ Document
1. Upload `knowledge/it-helpdesk-faq.md` to:
   - **SharePoint**: A SharePoint document library
   - **OneDrive**: OneDrive for Business

2. Get the sharing URL:
   - Right-click on the file
   - Select "Copy link"
   - Choose "People in your organization with the link can view"

#### Update the Declarative Agent Manifest
File: `appPackage/declarativeAgent.json`

**Replace the knowledge base URL:**
```json
"capabilities": [
  {
    "name": "OneDriveAndSharePoint",
    "items_by_url": [
      {
        "url": "https://yourtenant.sharepoint.com/sites/ITHelpDesk/Shared%20Documents/it-helpdesk-faq.md"
      }
    ]
  }
]
```

**Example:**
```json
{
  "url": "https://contoso.sharepoint.com/sites/ITKnowledge/Documents/it-helpdesk-faq.md"
}
```

### 3. App Manifest Configuration

File: `appPackage/manifest.json`

#### Update App ID (Optional but Recommended)
Generate a unique GUID for your app:
```json
"id": "YOUR-UNIQUE-GUID-HERE",
```

You can generate a GUID using:
- PowerShell: `[guid]::NewGuid()`
- Online: https://www.guidgenerator.com/

#### Update Developer Information
```json
"developer": {
  "name": "Your Organization Name",
  "websiteUrl": "https://www.yourcompany.com",
  "privacyUrl": "https://www.yourcompany.com/privacy",
  "termsOfUseUrl": "https://www.yourcompany.com/terms"
}
```

#### Update App Name (Optional)
```json
"name": {
  "short": "IT Support",
  "full": "IT HelpDesk Support Agent"
}
```

### 4. Icon Files

Replace the placeholder icon files with actual images:

#### Color Icon
- **File**: `appPackage/color.png`
- **Size**: 192x192 pixels
- **Format**: PNG
- **Content**: Full color icon representing IT HelpDesk
- **Background**: Can be colored

#### Outline Icon
- **File**: `appPackage/outline.png`
- **Size**: 32x32 pixels
- **Format**: PNG
- **Content**: Monochrome outline icon
- **Background**: Transparent

**Design Tips:**
- Use your company branding
- Make it recognizable as IT support
- Common symbols: headset, wrench, computer, help desk
- Keep it simple and clean

### 5. Customize Knowledge Base Content

File: `knowledge/it-helpdesk-faq.md`

Update the FAQ to match your organization:

#### Update Contact Information
Search and replace:
- `ext. 5555` → Your IT helpdesk extension
- `ithelpdesk@company.com` → Your IT helpdesk email
- `portal.company.com` → Your self-service portal URL
- `servicenow.company.com` → Your ServiceNow URL

#### Update Hours of Operation
Find the "Getting Help" section and update:
```markdown
**Hours of Operation:**
- Monday - Friday: 7:00 AM - 7:00 PM
- Saturday: 9:00 AM - 5:00 PM
```

#### Add Your Specific Procedures
- Password policies specific to your organization
- VPN connection details
- Printer names and locations
- Software approval processes
- Internal links and resources

### 6. Customize Agent Instructions

File: `appPackage/instructions.md`

#### Update Response Times
Find and update SLA response times:
```markdown
**Response times by priority:**
- **Critical**: 1 hour
- **High**: 4 hours
- **Medium**: 1 business day
- **Low**: 3 business days
```

#### Add Custom Guidelines
- Escalation procedures
- Special handling for executives
- After-hours support process
- Language preferences

#### Update Contact Information
Replace example contact details with your actual IT HelpDesk information.

## ServiceNow API Setup

### Required ServiceNow Configuration

#### 1. Enable REST API
In ServiceNow:
1. Navigate to **System Web Services > REST > REST API Explorer**
2. Ensure Table API is enabled
3. Test endpoint: `/api/now/table/incident`

#### 2. Create Service Account
1. Navigate to **User Administration > Users**
2. Create new user: `copilot_service_account`
3. Assign roles:
   - `itil` (for incident management)
   - `rest_api_explorer` (for API access)

#### 3. Configure API Access
1. Navigate to **System OAuth > Application Registry**
2. Create new OAuth client (if using OAuth)
3. Note the Client ID and Client Secret

#### 4. Test API Connection
```bash
# Test basic connectivity
curl -X GET "https://YOUR-INSTANCE.service-now.com/api/now/table/incident?sysparm_limit=1" \
  -H "Accept: application/json" \
  -u "username:password"
```

Expected response: JSON with incident data

### Optional ServiceNow Customizations

#### Custom Fields
If you have custom fields in your incident table:

1. Update `appPackage/servicenow-openapi.json`
2. Add custom fields to the `Incident` schema:
```json
"custom_field_name": {
  "type": "string",
  "description": "Description of custom field"
}
```

#### Additional Tables
To support beyond incidents (e.g., change requests):

1. Add new paths in `servicenow-openapi.json`
2. Add new functions in `serviceNowPlugin.json`
3. Update instructions in `instructions.md`

## Testing Your Configuration

### 1. Validate JSON Files
```bash
# Validate all JSON files
for file in appPackage/*.json; do
  echo "Validating $file..."
  python3 -m json.tool "$file" > /dev/null && echo "✓ Valid" || echo "✗ Invalid"
done
```

### 2. Test ServiceNow API
```bash
# Test list incidents
curl -X GET "https://YOUR-INSTANCE.service-now.com/api/now/table/incident?sysparm_limit=1" \
  -H "Accept: application/json" \
  -u "username:password"

# Test create incident
curl -X POST "https://YOUR-INSTANCE.service-now.com/api/now/table/incident" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -u "username:password" \
  -d '{"short_description":"Test from Copilot","description":"Testing API"}'
```

### 3. Verify Knowledge Base Access
1. Open the SharePoint/OneDrive URL in a browser
2. Ensure the file is accessible to your organization
3. Check file permissions

### 4. Package and Deploy
```bash
# Run the packaging script
./package.sh

# Upload ithelpdesk-agent.zip to Teams Admin Center
```

## Configuration Checklist

Use this checklist to ensure everything is configured:

- [ ] ServiceNow instance URL updated in `servicenow-openapi.json`
- [ ] ServiceNow authentication configured in `serviceNowPlugin.json`
- [ ] ServiceNow API tested and working
- [ ] Knowledge base uploaded to SharePoint/OneDrive
- [ ] Knowledge base URL updated in `declarativeAgent.json`
- [ ] Knowledge base content customized for your organization
- [ ] App ID (GUID) generated and set in `manifest.json`
- [ ] Developer information updated in `manifest.json`
- [ ] Color icon created (192x192 PNG)
- [ ] Outline icon created (32x32 PNG)
- [ ] Agent instructions customized in `instructions.md`
- [ ] Contact information updated in FAQ and instructions
- [ ] Response times/SLAs updated
- [ ] All JSON files validated
- [ ] Package created with `package.sh`

## Security Best Practices

### 1. Credential Management
- **Never** commit credentials to Git
- Use environment variables or Azure Key Vault
- Rotate service account passwords regularly
- Use OAuth 2.0 in production

### 2. API Security
- Enable IP whitelisting in ServiceNow
- Use HTTPS only (never HTTP)
- Implement rate limiting
- Monitor API usage logs

### 3. Data Privacy
- Review knowledge base for sensitive information
- Ensure proper RBAC in ServiceNow
- Enable audit logging
- Comply with GDPR/privacy regulations

### 4. Access Control
- Limit agent deployment to authorized users
- Review and approve app in Teams Admin Center
- Monitor usage and feedback
- Implement least-privilege access

## Troubleshooting Configuration Issues

### Issue: ServiceNow API returns 401 Unauthorized
**Solution:**
- Verify credentials are correct
- Check service account has proper roles
- Ensure API access is enabled in ServiceNow

### Issue: Knowledge base not loading
**Solution:**
- Verify SharePoint/OneDrive URL is correct
- Check file sharing permissions
- Ensure file is not blocked by DLP policies

### Issue: Agent doesn't appear in Teams
**Solution:**
- Verify app is approved in Teams Admin Center
- Check app assignment policies
- Ensure users have proper licenses

### Issue: JSON validation errors
**Solution:**
- Use online JSON validator
- Check for missing commas or brackets
- Ensure all strings are properly quoted

## Getting Help

If you encounter issues during configuration:

1. Review this guide thoroughly
2. Check the main README.md
3. Test each component individually
4. Review ServiceNow and Microsoft documentation
5. Contact your IT administrator

## Additional Resources

- [ServiceNow REST API Documentation](https://developer.servicenow.com/dev.do#!/reference/api/latest/rest)
- [Microsoft 365 Copilot Documentation](https://learn.microsoft.com/microsoft-365-copilot/)
- [Teams App Manifest Schema](https://learn.microsoft.com/microsoftteams/platform/resources/schema/manifest-schema)
- [Declarative Agents Best Practices](https://learn.microsoft.com/microsoft-365-copilot/extensibility/declarative-agent-best-practices)
