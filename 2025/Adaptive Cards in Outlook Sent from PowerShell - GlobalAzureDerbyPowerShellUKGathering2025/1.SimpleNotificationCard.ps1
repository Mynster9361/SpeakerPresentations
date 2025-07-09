# Import the ActionableMessages module
Import-Module ActionableMessages
# Import the Microsoft Graph Authentication module
Import-Module Microsoft.Graph.Authentication

# Set the environment variables for the script
$originatorId = $env:originatorId
$httpURL = $env:httpURL
$tenantId = $env:tenantId
$userToSendTo = $env:userToSendTo
$whatsNew = "https://mynster9361.github.io/posts/ActionableMessagesModuleWhatsNew/"

# Create a simple notification card
$card = New-AMCard -OriginatorId $originatorId
$title = New-AMTextBlock -Text "Notification Title" -Size "Large" -Weight "Bolder"
$notificationText = New-AMTextBlock -Text "This is a simple notification message." -Wrap $true
$actionOpenUrl = New-AMOpenUrlAction -Title "View Details" -Url $whatsNew
$actionSet = New-AMActionSet -Id "actionSet" -Actions @($actionOpenUrl)
Add-AMElement -Card $card -Element $title
Add-AMElement -Card $card -Element $notificationText
Add-AMElement -Card $card -Element $actionSet

# Export the card for email
$params = Export-AMCardForEmail -Card $card -Subject "Simple Notification" -ToRecipients $userToSendTo -CreateGraphParams

Connect-MgGraph -Scopes "Mail.Send" -NoWelcome -TenantId $tenantId
Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/me/sendMail" -Body $params
