# Import the ActionableMessages module
Import-Module ActionableMessages
# Import the Microsoft Graph Authentication module
Import-Module Microsoft.Graph.Authentication

$originatorId = $env:originatorId
$httpURL = $env:httpURL
$tenantId = $env:tenantId
$userToSendTo = $env:userToSendTo
$whatsNew = "https://mynster9361.github.io/posts/ActionableMessagesModuleWhatsNew/"


# Create an application usage survey card using the prebuilt function
$appCardParams = @{
  OriginatorId     = "software-survey-system"
  ApplicationName  = "Adobe Photoshop"
  Version          = "2025"
  Vendor           = "Adobe"
  Department       = "Design"
  TicketNumber     = "SAM-2023-004"
  ResponseEndpoint = $httpURL
}

$appCard = New-AMApplicationUsageSurveyCard @appCardParams

Show-AMCardPreview -card $appCard

# Tenant ID, Client ID, and Client Secret for the MS Graph API
$tenantId = $env:tenantId
$clientId = $env:clientId
$clientSecret = $env:clientSecret
$userToSendFrom = $env:userToSendFrom
$userToSendTo = $env:userToSendTo

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
