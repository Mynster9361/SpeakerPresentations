# Azure

- Create Subscription > Resource Group > Log analytics workspace
- Create app registration
- Assign permissions 

| Provider            | Permission                               | Why                                                                                                                                                  |
| :------------------ | :--------------------------------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Microsoft Graph** | `Application.Read.All`                   | To read service principals and their roles.                                                                                                          |
| **Microsoft Graph** | `Directory.Read.All`                     | To read /oauth2PermissionGrants and their roles. If you do not care about delegated permissions change the permissionType parameter to "Application" |
| **Azure IAM**       | `Log Analytics Reader` (RBAC permission) | To query the `MicrosoftGraphActivityLogs` table.                                                                                                     |

- Add federated credentials
    * **Issuer**: `https://token.actions.githubusercontent.com`
    * **Subject Identifier**: `repo:<ORG>/<REPO>:ref:refs/heads/main` (Adjust for your branch).
    * **Audience**: `api://AzureADTokenExchange`

# Github
- Settings
- Secrets and variables > Actions
- Add secrets
    * AZURE_CLIENT_ID
    * AZURE_TENANT_ID
    * LOG_ANALYTICS_WORKSPACE_ID

```yaml
name: "LPM Permission Audit"

on:
  schedule:
    - cron: "0 6 * * 1"  # Every Monday at 06:00 UTC
  workflow_dispatch:     # Allow manual runs

permissions:
  id-token: write      # Required for OIDC
  contents: write      # Required to commit state files

jobs:
  audit:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout Code
        uses: actions/checkout@v6
        with:
          fetch-depth: 0

      - name: Run LeastPrivilegedMSGraph Audit
        uses: Mynster9361/Least_Privileged_MSGraph@v0.1.0
        with:
          tenantId: ${{ secrets.AZURE_TENANT_ID }}
          clientId: ${{ secrets.AZURE_CLIENT_ID }}
          logAnalyticsWorkspaceId: ${{ secrets.LOG_ANALYTICS_WORKSPACE_ID }}
          daysToQuery: 7
          enableGitCommit: true
```
