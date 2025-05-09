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

Show-AMCardPreview -Card $appCard

# Export the card for email
$params = Export-AMCardForEmail -Card $appCard -Subject "Application Usage Survey" -ToRecipients $userToSendTo -CreateGraphParams

Connect-MgGraph -Scopes "Mail.Send" -NoWelcome
Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/me/sendMail" -Body $params