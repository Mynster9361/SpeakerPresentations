# Import the ActionableMessages module

Import-Module ActionableMessages

# Tenant ID, Client ID, and Client Secret for the MS Graph API
$OriginatorId = ""
$tenantId = ""
$clientId = ""
$clientSecret = ""
$userToSendFrom = ""
$userToSendTo = ""
$endPoint = ""

# Create an application usage survey card using the prebuilt function
$appCardParams = @{
  OriginatorId     = $OriginatorId
  ApplicationName  = "Adobe Photoshop"
  Version          = "2025"
  Vendor           = "Adobe"
  Department       = "Design"
  TicketNumber     = "SAM-2023-004"
  ResponseEndpoint = $endPoint
}

$appCard = New-AMApplicationUsageSurveyCard @appCardParams

Show-AMCardPreview -card $appCard


# Prepare the card for email
$graphParams = Export-AMCardForEmail -Card $appCard -Subject "Application Usage Survey" -ToRecipients $userToSendTo -CreateGraphParams
$params = $graphParams | ConvertTo-Json -Depth 50


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

# Graph API BASE URI
$graphApiUri = "https://graph.microsoft.com/v1.0"
$uri = "$graphApiUri/users/$userToSendFrom/sendMail"
$request = Invoke-RestMethod -Method POST -Uri $uri -Headers $authHeaders -Body $params
$request
