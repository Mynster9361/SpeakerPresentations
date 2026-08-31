# Prep for session

## Authentication with a secret

**Create application**

- Add a secret
- Authenticate with EntraAuth

```powershell
$tenantId = "<Tenant-ID>"

$secretClientId = "<secret_demo_client_id>"
$clientSecret = "<secret_demo_client_secret>" | ConvertTo-SecureString -AsPlainText -Force

Connect-EntraService -ClientID $secretClientId -TenantID $tenantId -ClientSecret $clientSecret

Get-EntraToken | select -ExcludeProperty TokenData, AccessToken, ClientID, TenantID, Issuer
```

## Authentication with a Certificate

**Create application**

- [Create self signed certificate](https://learn.microsoft.com/en-us/entra/identity-platform/howto-create-self-signed-certificate#create-and-export-your-public-certificate)
- Add Certificate to the application
- Authenticate with EntraAuth `-Certificate`, `-CertificatePath` + `-CertificatePassword`

```powershell
$tenantId = "<Tenant-ID>"
$certClientId = "<cert_demo_client_id>"

<#
If you utilize the terraform in the repo you can utilize the bbelow for the certificate part
# terraform wrote these next to main.tf - never commit the .key.pem, see .gitignore
$certPath = Join-Path $PSScriptRoot "terraform\generated\cert-demo.cert.pem"
$keyPath = Join-Path $PSScriptRoot "terraform\generated\cert-demo.key.pem"

$cert = [System.Security.Cryptography.X509Certificates.X509Certificate2]::CreateFromPemFile($certPath, $keyPath)
$cert.Thumbprint
#>

$certname = "Mynster"
$cert = New-SelfSignedCertificate -Subject "CN=$certname" -CertStoreLocation "Cert:\CurrentUser\My" -KeyExportPolicy Exportable -KeySpec Signature -KeyLength 2048

Export-Certificate -Cert $cert -FilePath "./$certname.cer"
# Upload the cert to your application

Connect-EntraService -ClientID $certClientId -TenantID $tenantId -Certificate $cert

Get-EntraToken | select -ExcludeProperty TokenData, AccessToken, ClientID, TenantID, Issuer
```

## Authentication with federated credentials

**Create application**
**Create Github repository**

- Setup up federated credentials
    Organization ID: [https://api.github.com/users/`Your_Github_UserName`](https://api.github.com/users/`Your_Github_UserName`)

    Example: https://api.github.com/users/Mynster9361

    Repository ID: [https://api.github.com/repos/`Repository_Owner`/`Repository`](https://api.github.com/repos/`Repository_Owner`/`Repository`)

    Example: https://api.github.com/repos/Mynster9361/SpeakerPresentations

    >**NOTE**: You needd to specifically go to `Settings` -> `Actions` -> `OIDC` and enabbble `Use immutable subject claim` for auth to work
    >
    >**Bonus info**: if for some reason you are not able to do the above you can edit the Subject identifier manually to exclude the id's and thus not have to enable above setting*
    ```
    Organisation: Mynster9361
    Organization ID: 66535357
    Repositroy: SpeakerPresentations
    Repository ID: 980477961
    Entity type: Branch
    GitHub branch name: main
    ```
- Test with a github action that authenticates to msgraph from main branch `-Federated`


```yml
name: test

on:
    workflow_dispatch:

jobs:
    get-token:
        runs-on: windows-latest
        permissions:
            id-token: write # Require write permission to Fetch an OIDC token.
        steps:
            - name: Get an Entra token via the federated credential
              shell: pwsh
              run: |
                  Install-Module EntraAuth -Scope CurrentUser -Force

                  Connect-EntraService -ClientID $env:CLIENT_ID -TenantID $env:AZURE_TENANT_ID -Federated

                  Get-EntraToken | select -ExcludeProperty TokenData, AccessToken, ClientID, TenantID, Issuer
              env:
                  AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
                  CLIENT_ID: ${{ secrets.CLIENT_ID }}

```



## Authentication with managed identity

**Create Azure Automation account**

- Assign msgraph permissions to the managed identity.
    ```powershell
    $miId = "" # Managed Identity ID

    $miRoleAssignment = @{
	    principalId = $miId
	    resourceId = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
	    appRoleId = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All (Application)
    }

    Invoke-entrarequest -Path "servicePrincipals/$miId/appRoleAssignments" -body $miRoleAssignment

    ```
- Test login `-Identity`

```powershell
Connect-EntraService -Identity

Get-EntraToken | select -ExcludeProperty TokenData, AccessToken, ClientID, TenantID, Issuer
```
