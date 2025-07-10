<#
.SYNOPSIS
    Demonstrates how to handle throttling when making API calls to the Microsoft Graph API.

.DESCRIPTION
    This script shows how to handle throttling responses from the Microsoft Graph API.
    It makes repeated API calls to the /subscriptions endpoint and handles the 429 Too Many Requests error by implementing retry logic.

.NOTES
    MS Docs on how to handle throttling:
    https://learn.microsoft.com/en-us/graph/throttling

.PARAMETER tenantId
    The tenant ID of the Azure AD tenant.

.PARAMETER clientId
    The client ID of the registered application.

.PARAMETER clientSecret
    The client secret of the registered application.

.EXAMPLE
    # Set environment variables for tenantId, clientId, and clientSecret
    $env:tenantId = "your-tenant-id"
    $env:clientId = "your-client-id"
    $env:clientSecret = "your-client-secret"

    # Run the script
    .\2_Throtling.ps1

    # The script will make repeated API calls and handle throttling responses.
#>

# Tenant ID, Client ID, and Client Secret for the MS Graph API
$tenantId = $env:tenantId
$clientId = $env:clientId
$clientSecret = $env:clientSecret

# Default Token Body
$tokenBody = @{
    Grant_Type    = "client_credentials"
    Scope         = "https://graph.microsoft.com/.default"
    Client_Id     = $clientId
    Client_Secret = $clientSecret
}

# Request a Token
$tokenResponse = Invoke-RestMethod -Uri "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token" -Method POST -Body $tokenBody

# Setting up the authorization headers
$authHeaders = @{
    "Authorization" = "Bearer $($tokenResponse.access_token)"
    "Content-type"  = "application/json"
}

# URI for the /subscriptions endpoint
$uri = "https://graph.microsoft.com/v1.0/subscriptions"

# The following will return a 429 error after 40 requests in 20 seconds which is the limit for the /Subscription endpoint
# The error message will contain a Retry-After header with the number of seconds to wait before making another request
$counter = 0
do {
    Write-Output $counter
    try {
        Invoke-RestMethod -Method Get -Uri $uri -Headers $authHeaders
        $counter++
    }
    catch {
        $Error[0]
        $Error[0].Exception.Response.Headers["Retry-After"]
        <#
Invoke-RestMethod:
Line |
  32 |          Invoke-RestMethod -Method Get -Uri $uri -Headers $authHeaders
     |          ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     |
{
  "error": {
    "code": "TooManyRequests",
    "message": "Too many requests from Identifier:887d150d-8ad7-403f-9d30-ea1523e9573c under category:throttle.aad.ags.subscriptionservice.app.list. Please try again later.",
    "innerError": {
      "date": "2025-07-09T10:08:57",
      "request-id": "06902c8f-f139-4d93-a833-4fcb14b89f06",
      "client-request-id": "06902c8f-f139-4d93-a833-4fcb14b89f06"
    }
  }
}
        #>
        break
    }

} while (
    $true
)


# This will make sure that if we hit the limit we will wait for the time specified in the Retry-After header and then try again
# The Retry-After header is in seconds so we will add 1 second to the delay to make sure we are not hitting the limit again
# The hastable shows it like this:
# Key                       Value
# Retry-After               {20}
do {
    $throtleState = $null
    try {
        Invoke-RestMethod -Method Get -Uri $uri -Headers $authHeaders
    }
    catch {
        # https://learn.microsoft.com/en-us/graph/throttling#what-happens-when-throttling-occurs
        # The above url mentions we have a way of knowing how long we should wait this comes down to ms but the Retry-After header is in seconds the hastable shows it like this:
        # Key                       Value
        # Retry-After               {20}
        # We will add 1 second to the delay to make sure we are not hitting the limit again
        if ($_.Exception.Response.StatusCode.Value__ -eq 429) {
            [int]$Delay = 15
            [int]$Delay = ([int]$_.Exception.Response.Headers["Retry-After"] + 1)
            Start-Sleep -Seconds $Delay
            $throtleState = $true

        }
        else {
            # If for some reason we get a different error we will throw it
            throw ($_)
        }
    }

} while ($throtleState -eq $true)
