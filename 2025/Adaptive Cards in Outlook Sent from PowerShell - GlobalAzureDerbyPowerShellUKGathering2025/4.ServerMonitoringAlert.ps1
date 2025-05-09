# Import the ActionableMessages module
Import-Module ActionableMessages
# Import the Microsoft Graph Authentication module
Import-Module Microsoft.Graph.Authentication

$originatorId = $env:originatorId
$tenantId = $env:tenantId
$userToSendTo = $env:userToSendTo
$httpURL = $env:httpURL
$whatsNew = "https://mynster9361.github.io/posts/ActionableMessagesModuleWhatsNew/"

# Create a server monitoring alert card using the prebuilt function
$serverCardParams = @{
  OriginatorId   = "monitoring-system"
  Server         = "Server XYZ"
  Status         = "Offline"
  ServerType     = "Web Server"
  IPAddress      = "192.168.1.1"
  MonitoringUrl  = $httpURL
  ActionUrl      = $httpURL
  ActionTitle    = "Restart Server"
  AcknowledgeUrl = $httpURL
}

$serverCard = New-AMServerMonitoringCard @serverCardParams



# Export the card for email
$params = Export-AMCardForEmail -Card $serverCard -Subject "Server Monitoring Alert" -ToRecipients $userToSendTo -CreateGraphParams

Connect-MgGraph -Scopes "Mail.Send" -NoWelcome
Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/me/sendMail" -Body $params