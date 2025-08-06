# Just going over some logic app and handling the response from the adaptive card
# regex:https://.+\.logic\.azure\.com/
# Header: CARD-UPDATE-IN-BODY - true

$uri = ""
$testBody = @{
  "Action"    = "Approve"
  "New_Owner" = "John Doe"
  "Old_Owner" = "Jane Doe"
  "Objects"   = @(
    @{
      "ObjectId"   = "12345"
      "ObjectType" = "Group"
    }
  )
}
$testBodyJson = $testBody | ConvertTo-Json -Depth 10
Invoke-RestMethod -Uri $uri -Method POST -Body $testBodyJson -ContentType "application/json"

$simpleAccountCardParams = @{
  OriginatorId     = "0882e9ee-a02c-40c8-aad9-d4800d79d495"
  Username         = "asmith"
  AccountOwner     = "Alice Smith"
  LastLoginDate    = (Get-Date).AddDays(-60)
  InactiveDays     = 60
  ResponseEndpoint = $uri
  ResponseBody     = "{`"ticketNumber`": `"$TicketNumber`", `"username`": `"$Username`", `"accountStatus`": `"{{account-status.value}}`", `"comment`": `"{{comment.value}}`", `"transferTo`": `"{{transfer-to.value}}`}"
}

$accountCard = New-AMAccountVerificationCard @simpleAccountCardParams



# Tenant ID, Client ID, and Client Secret for the MS Graph API
# https://outlook.office.com/connectors/oam/publish/Show?id=0882e9ee-a02c-40c8-aad9-d4800d79d495&scope=TestUsers
$tenantId = $env:tenantId
$clientId = $env:clientId
$clientSecret = $env:clientSecret
$userToSendFrom = $env:userToSendFrom
$userToSendTo = $env:userToSendTo

# Prepare the card for email
$graphParams = Export-AMCardForEmail -Card $accountCard -Subject "Account Verification" -ToRecipients $userToSendTo -CreateGraphParams -FallbackText "Your email client doesn't support Adaptive Cards"
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
