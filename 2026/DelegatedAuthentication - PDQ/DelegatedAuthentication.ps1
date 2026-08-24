#Requires -modules EntraAuth
#Requires -modules Az.Accounts

#Region Delegated authentication

#Region Normal authentication

Connect-EntraService -ClientID Graph

Get-EntraToken

#EndRegion Normal authentication

#Region Device Code Authentication

# Reuse our previous connection and request the id utilizing the following
# invoke-entraRequest -Path 'organization?$select=id'

Connect-EntraService -DeviceCode -ClientID Graph -TenantID <Tenant-ID>

Get-EntraToken

#EndRegion Device Code Authentication

#Region reAuthenticate with a previous token

# There is 2 kinds a refresh token object and a refresh token we will be using refresh token object just to avoid having to specify ClientId, TenantId,
$refreshToken = Get-EntraToken

Connect-EntraService -RefreshTokenObject $refreshToken

Get-EntraToken

#EndRegion reAuthenticate with a previous token

#Region Reusing a token from another provider

Connect-AzAccount

Connect-EntraService -AsAzAccount

Get-EntraToken

#EndRegion Reusing a token from another provider

#EndRegion Delegated authentication

#Region Delegated authentication (Multiple Services)

#Region Connecting to multiple services at once (multiple prompts)

Connect-EntraService -Service Graph, GraphBeta, Azure -ClientID Azure

Get-EntraToken

#EndRegion Connecting to multiple services at once (multiple prompts)


#Region Connecting to multiple services at once (Method 1)

Connect-AzAccount

Connect-EntraService -AsAzAccount -Service Graph, GraphBeta, Azure

Get-EntraToken

#EndRegion Connecting to multiple services at once (Method 1)

#Region Connecting to multiple services at once (Method 2)

Connect-EntraService -Service Graph -ClientID Graph

Connect-EntraService -Service Graph, GraphBeta, Azure -UseRefreshToken -ClientID Graph

Get-EntraToken

#EndRegion Connecting to multiple services at once (Method 2)

#EndRegion Delegated authentication (Multiple Services)
