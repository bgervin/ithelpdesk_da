# IT HelpDesk Declarative Agent for Microsoft 365 Copilot

An intelligent IT HelpDesk assistant that integrates with Microsoft 365 Copilot to help employees find answers to common IT questions and manage ServiceNow tickets.

## Features

### 🎯 Core Capabilities
- **Knowledge Base Integration**: Instantly access answers to common IT questions from a comprehensive FAQ
- **ServiceNow Ticket Management**: Create, view, update, and close IT support tickets
- **Conversational Interface**: Natural language interaction through Microsoft 365 Copilot
- **Quick Actions**: Pre-configured conversation starters for common IT tasks

### 💡 Common Use Cases
- Password reset instructions
- Software access requests
- VPN troubleshooting
- Printer setup guidance
- Hardware issue reporting
- Network connectivity problems
- Security incident reporting
- And much more!

## Project Structure

```
ithelpdesk_da/
├── appPackage/                          # Application package files
│   ├── manifest.json                    # Microsoft 365 app manifest
│   ├── declarativeAgent.json            # Declarative agent configuration
│   ├── instructions.md                  # Agent behavior instructions
│   ├── serviceNowPlugin.json            # ServiceNow API plugin manifest
│   ├── servicenow-openapi.json          # OpenAPI specification for ServiceNow
│   ├── color.png                        # App color icon (192x192)
│   └── outline.png                      # App outline icon (32x32)
├── knowledge/                           # Knowledge base documents
│   └── it-helpdesk-faq.md              # IT HelpDesk FAQ knowledge base
├── .gitignore                           # Git ignore rules
└── README.md                            # This file
```

## Prerequisites

- Microsoft 365 subscription with Copilot enabled
- ServiceNow instance with API access
- Access to Microsoft Teams Admin Center or Copilot Studio
- (Optional) Teams Toolkit for Visual Studio Code for development

## Configuration

### 1. ServiceNow Configuration

Before deploying, you need to configure the ServiceNow connection:

1. **Update the OpenAPI Specification** (`appPackage/servicenow-openapi.json`):
   - Replace `https://your-instance.service-now.com` with your actual ServiceNow instance URL
   
2. **Configure Authentication**:
   - The current configuration uses basic authentication
   - For production, consider using OAuth 2.0 (configuration included in the OpenAPI spec)
   - Update the `auth` section in `serviceNowPlugin.json` as needed

3. **ServiceNow API Setup**:
   - Ensure your ServiceNow instance has the Table API enabled
   - Create a service account with appropriate permissions for incident management
   - Configure API access policies in ServiceNow

### 2. Knowledge Base Configuration

The knowledge base is referenced in `declarativeAgent.json`:

```json
"capabilities": [
  {
    "name": "OneDriveAndSharePoint",
    "items_by_url": [
      {
        "url": "knowledge/it-helpdesk-faq.md"
      }
    ]
  }
]
```

**To use the knowledge base:**
1. Upload `knowledge/it-helpdesk-faq.md` to a SharePoint site or OneDrive location
2. Update the `url` in `declarativeAgent.json` with the actual SharePoint/OneDrive URL
3. Ensure the file has appropriate sharing permissions for your organization

### 3. App Icons

Create proper icon files:
- **color.png**: 192x192 pixel color icon (replace placeholder)
- **outline.png**: 32x32 pixel transparent outline icon (replace placeholder)

Use your organization's branding and IT HelpDesk imagery.

## Deployment

### Option 1: Deploy via Teams Toolkit (Recommended for Development)

1. **Install Teams Toolkit**:
   - Install the Teams Toolkit extension in Visual Studio Code
   - Or use Teams Toolkit CLI: `npm install -g @microsoft/teamsfx-cli`

2. **Open the project** in Visual Studio Code

3. **Configure environment**:
   - Update ServiceNow URLs and authentication
   - Update knowledge base URLs

4. **Deploy**:
   - Click on Teams Toolkit in VS Code sidebar
   - Select "Provision in the cloud"
   - Select "Deploy to the cloud"
   - Select "Publish to Teams"

### Option 2: Manual Deployment via Teams Admin Center

1. **Create App Package**:
   ```bash
   cd appPackage
   zip -r ithelpdesk-agent.zip *
   ```

2. **Upload to Teams**:
   - Go to Microsoft Teams Admin Center (https://admin.teams.microsoft.com)
   - Navigate to "Teams apps" > "Manage apps"
   - Click "Upload" and select `ithelpdesk-agent.zip`
   - Configure app policies and permissions

3. **Approve and Deploy**:
   - Review the app submission
   - Approve for your organization
   - Assign to users or groups

### Option 3: Deploy via Copilot Studio

1. **Open Copilot Studio**: https://copilotstudio.microsoft.com
2. **Create New Agent**:
   - Select "Declarative Agent"
   - Import the manifest files
3. **Configure**:
   - Upload the app package
   - Configure the ServiceNow plugin
   - Link the knowledge base
4. **Test and Publish**:
   - Test in Copilot Studio
   - Publish to Microsoft 365

## Testing

### Test in Microsoft Teams

1. Open Microsoft Teams
2. Go to "Apps" in the left sidebar
3. Search for "IT HelpDesk Agent"
4. Click on the app to open it
5. Try conversation starters or ask IT-related questions

### Sample Test Queries

```
"How do I reset my password?"
"Create a ticket for my laptop issue"
"Show me my open ServiceNow tickets"
"I can't connect to the VPN"
"How do I install Microsoft Office?"
"My printer isn't working"
```

### Testing ServiceNow Integration

Ensure your ServiceNow API is accessible:

```bash
# Test list incidents (replace with your instance URL and credentials)
curl -X GET "https://your-instance.service-now.com/api/now/table/incident" \
  -H "Accept: application/json" \
  -u "username:password"

# Test create incident
curl -X POST "https://your-instance.service-now.com/api/now/table/incident" \
  -H "Content-Type: application/json" \
  -H "Accept: application/json" \
  -u "username:password" \
  -d '{"short_description":"Test incident from API","description":"Testing ServiceNow integration"}'
```

## Usage Examples

### Example 1: Getting Help with Password Reset

**User**: "How do I reset my password?"

**Agent**: "I can help you with that! Here are the steps to reset your password:
1. Visit the self-service portal at https://portal.company.com
2. Click on 'Forgot Password'
3. Enter your employee ID and registered email address
4. Check your email for a verification code
5. Enter the verification code on the portal
6. Create a new password following the requirements..."

### Example 2: Creating a ServiceNow Ticket

**User**: "Create a ticket for my laptop that won't turn on"

**Agent**: "I'll help you create a ServiceNow ticket for your laptop issue. Let me gather some information:
- Is this a complete power failure (no lights at all) or does it show any activity?
- When did this issue start?
- Have you tried connecting it to a power source?
- How urgent is this issue for your work?"

**User**: "It's completely dead, started this morning, already tried power. It's urgent - I need it for meetings."

**Agent**: "I've created ServiceNow ticket INC0012345 for your laptop power issue. The ticket has been marked as High priority and assigned to the Hardware Support team. They typically respond within 4 hours for high-priority hardware issues..."

### Example 3: Checking Ticket Status

**User**: "What's the status of my tickets?"

**Agent**: "Let me check your open ServiceNow tickets... You have 2 active tickets:

1. **INC0012345** - Laptop won't turn on
   - Status: In Progress
   - Priority: High
   - Assigned to: Hardware Support Team
   - Created: 2 hours ago
   
2. **INC0012334** - Request access to Adobe Creative Suite
   - Status: Awaiting Approval
   - Priority: Medium
   - Assigned to: Access Management Team
   - Created: 1 day ago"

## Customization

### Modifying the Knowledge Base

Edit `knowledge/it-helpdesk-faq.md` to:
- Add new FAQ entries
- Update procedures and links
- Reflect your organization's specific IT policies
- Include custom troubleshooting steps

### Customizing Agent Behavior

Edit `appPackage/instructions.md` to:
- Adjust the agent's tone and style
- Add specific guidelines for your organization
- Include custom workflows
- Define escalation procedures

### Adding More ServiceNow Actions

Edit `appPackage/servicenow-openapi.json` to:
- Add additional ServiceNow endpoints
- Support change requests, problems, or other ITSM processes
- Customize field mappings

Then update `appPackage/serviceNowPlugin.json` to expose new functions.

### Modifying Conversation Starters

Edit `appPackage/declarativeAgent.json`:

```json
"conversation_starters": [
  {
    "title": "Your custom starter title",
    "text": "Your custom starter text"
  }
]
```

## Security Considerations

### Best Practices

1. **Authentication**:
   - Use OAuth 2.0 for ServiceNow integration in production
   - Never hardcode credentials in configuration files
   - Use Azure Key Vault or similar for credential management

2. **Data Privacy**:
   - Ensure knowledge base documents don't contain sensitive information
   - Review ServiceNow data access policies
   - Implement proper RBAC (Role-Based Access Control)

3. **Network Security**:
   - Ensure ServiceNow API is only accessible via secure channels
   - Use HTTPS for all API communications
   - Consider IP whitelisting for API access

4. **Compliance**:
   - Review data residency requirements
   - Ensure GDPR/privacy compliance
   - Maintain audit logs for ticket access

## Troubleshooting

### Common Issues

**Issue**: Agent doesn't respond to questions
- **Solution**: Check that the knowledge base URL is accessible and properly configured

**Issue**: ServiceNow integration fails
- **Solution**: Verify ServiceNow instance URL, credentials, and API permissions

**Issue**: "Unlicensed" error when using the agent
- **Solution**: Ensure users have appropriate Microsoft 365 Copilot licenses

**Issue**: Agent can't find information in the knowledge base
- **Solution**: Verify knowledge base file permissions and sharing settings

### Getting Help

For issues with:
- **Microsoft 365 Copilot**: Contact Microsoft Support
- **ServiceNow**: Check ServiceNow documentation or contact ServiceNow support
- **This Implementation**: File an issue in this repository

## Maintenance

### Regular Updates

1. **Knowledge Base**: Review and update FAQ quarterly
2. **ServiceNow Schema**: Keep OpenAPI spec in sync with ServiceNow changes
3. **Agent Instructions**: Refine based on user feedback
4. **Dependencies**: Keep manifest schemas up to date

### Monitoring

Track these metrics:
- Number of questions answered without creating tickets
- Ticket creation success rate
- User satisfaction scores
- Common queries and issues

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

[Specify your license here]

## Support

For questions or issues:
- **Internal IT HelpDesk**: ext. 5555
- **Project Issues**: [GitHub Issues]
- **Documentation**: This README and inline comments

## Additional Resources

- [Microsoft 365 Copilot Documentation](https://learn.microsoft.com/microsoft-365-copilot/)
- [Declarative Agents Overview](https://learn.microsoft.com/microsoft-365-copilot/extensibility/overview-declarative-agent)
- [ServiceNow REST API Documentation](https://developer.servicenow.com/dev.do)
- [Teams Toolkit Documentation](https://learn.microsoft.com/microsoftteams/platform/toolkit/teams-toolkit-fundamentals)

---

**Version**: 1.0.0  
**Last Updated**: October 2025  
**Maintained by**: IT HelpDesk Team