<#
Using the gui to design the card
https://amdesigner.azurewebsites.net/
#>
# Import the ActionableMessages module
Import-Module ActionableMessages
# Import the Microsoft Graph Authentication module
Import-Module Microsoft.Graph.Authentication

$originatorId = $env:originatorId
$tenantId = $env:tenantId
$userToSendTo = $env:userToSendTo
$httpURL = $env:httpURL
$whatsNew = "https://mynster9361.github.io/posts/ActionableMessagesModuleWhatsNew/"

# Set the path to the Adaptive Card Designer

$jsonCard = get-content "Adaptive Cards in Outlook Sent from PowerShell/card.json" -Raw

$card = ConvertFrom-AMJson -Json $jsonCard
$card

# Create a new card
$card = New-AMCard -OriginatorId "Replace-Me-With-Your-OriginatorId" -Version "1.0"

# Add elements to the card
$container_6343565f_52eb_c87b_c815_b772a86f1aca = New-AMContainer -Id "6343565f-52eb-c87b-c815-b772a86f1aca" -Style "emphasis" -Padding "Default"
Add-AMElement -Card $card -Element $container_6343565f_52eb_c87b_c815_b772a86f1aca
$textblock_d9c56323_fe1a_e090_1df5_311743b856cd = New-AMTextBlock -Text "Notification" -Wrap $true
Add-AMElement -Card $card -Element $textblock_d9c56323_fe1a_e090_1df5_311743b856cd -ContainerId "6343565f-52eb-c87b-c815-b772a86f1aca"
$container_03a273b0_e511_5f0d_3a44_1eddaa03a8a5 = New-AMContainer -Id "03a273b0-e511-5f0d-3a44-1eddaa03a8a5" -Padding "Default"
Add-AMElement -Card $card -Element $container_03a273b0_e511_5f0d_3a44_1eddaa03a8a5
$textblock_231d74e7_5c53_6ec8_102d_718dc936bc09 = New-AMTextBlock -Text "You have been mentioned in the conversation on Budget reports." -Size "Large" -Weight "Bolder" -Wrap $true
Add-AMElement -Card $card -Element $textblock_231d74e7_5c53_6ec8_102d_718dc936bc09 -ContainerId "03a273b0-e511-5f0d-3a44-1eddaa03a8a5"
$container_ConversationWrapper = New-AMContainer -Id "ConversationWrapper" -Padding "Default"
Add-AMElement -Card $card -Element $container_ConversationWrapper
$column_0 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Carlos_Slattery.png" -AltText "Rob Young Avatar" -Size "Small")
)
$column_1 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "Rob Young mentioned you" -Color "Light" -Wrap $true),
    (New-AMTextBlock "**@Kat Larsson** Can you check these numbers are accurate?" -Wrap $true)
)
$columnset_53fac03a_36e0_c77b_546a_01f4c727a73e = New-AMColumnSet -Id "53fac03a-36e0-c77b-546a-01f4c727a73e" -Columns @($column_0, $column_1)
Add-AMElement -Card $card -Element $columnset_53fac03a_36e0_c77b_546a_01f4c727a73e -ContainerId "ConversationWrapper"
$column_0_1 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Kat_Larsson.png" -AltText "Your Avatar" -Size "Small")
)
$column_1_2 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "You replied" -Color "Light" -Wrap $true),
    (New-AMTextBlock "**@Rob Young** I checked the numbers, they're accurate." -Wrap $true)
)
$columnset_73fac03a_36e0_c77b_546a_01f4c727a73e = New-AMColumnSet -Id "73fac03a-36e0-c77b-546a-01f4c727a73e" -Columns @($column_0_1, $column_1_2)
Add-AMElement -Card $card -Element $columnset_73fac03a_36e0_c77b_546a_01f4c727a73e -ContainerId "ConversationWrapper"
$column_0_3 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Colin_Ballinger.png" -AltText "Collin Ballinger Avatar" -Size "Small")
)
$column_1_4 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "Collin Ballinger mentioned Daisy Philips" -Color "Light" -Wrap $true),
    (New-AMTextBlock "**@Daisy Philips** Can you check these numbers are accurate?" -Wrap $true)
)
$columnset_76fac03a_36e0_c77b_546a_01f4c727a73e = New-AMColumnSet -Id "76fac03a-36e0-c77b-546a-01f4c727a73e" -Columns @($column_0_3, $column_1_4)
Add-AMElement -Card $card -Element $columnset_76fac03a_36e0_c77b_546a_01f4c727a73e -ContainerId "ConversationWrapper"
$column_0_5 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Daisy_Phillips.png" -AltText "Daisy Philips Avatar" -Size "Small")
)
$column_1_6 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "Daisy Philips left a comment" -Color "Light" -Wrap $true),
    (New-AMTextBlock "**@Collin Ballinger** I think it looks fine." -Wrap $true),
    (New-AMTextBlock "8 more replies" -Color "Accent" -Wrap $true)
)
$columnset_76fac3a_36e0_c77b_546a_01f4c727a73e = New-AMColumnSet -Id "76fac3a-36e0-c77b-546a-01f4c727a73e" -Columns @($column_0_5, $column_1_6)
Add-AMElement -Card $card -Element $columnset_76fac3a_36e0_c77b_546a_01f4c727a73e -ContainerId "ConversationWrapper"
$column_0_7 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Colin_Ballinger.png" -AltText "Collin Ballinger Avatar" -Size "Small")
)
$column_1_8 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "Collin Ballinger left a comment" -Color "Light" -Wrap $true),
    (New-AMTextBlock "I think we need to hear from Kat." -Wrap $true)
)
$columnset_76fac3a_c77b_546a_01f4c727a73e = New-AMColumnSet -Id "76fac3a-c77b-546a-01f4c727a73e" -Columns @($column_0_7, $column_1_8)
Add-AMElement -Card $card -Element $columnset_76fac3a_c77b_546a_01f4c727a73e -ContainerId "ConversationWrapper"
$container_5db09e08_ae3d_95a8_6562_8e0a4682fcb1 = New-AMContainer -Id "5db09e08-ae3d-95a8-6562-8e0a4682fcb1" -Style "emphasis" -Padding "Default"
Add-AMElement -Card $card -Element $container_5db09e08_ae3d_95a8_6562_8e0a4682fcb1
$column_0_9 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Daisy_Phillips.png" -AltText "Daisy Philips Avatar" -Size "Small")
)
$column_1_10 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "Daisy Philips mentioned you" -Color "Light" -Wrap $true),
    (New-AMTextBlock "**@Kat Larsson** We do need to proceed ASAP to unblock the Dev team." -Wrap $true)
)
$columnset_54fac03a_36e0_c77b_546a_01f4c727a73e = New-AMColumnSet -Id "54fac03a-36e0-c77b-546a-01f4c727a73e" -Columns @($column_0_9, $column_1_10)
Add-AMElement -Card $card -Element $columnset_54fac03a_36e0_c77b_546a_01f4c727a73e -ContainerId "5db09e08-ae3d-95a8-6562-8e0a4682fcb1"
$container_f30f6dab_8ddb_877b_001c_d350c0a03a53 = New-AMContainer -Id "f30f6dab-8ddb-877b-001c-d350c0a03a53" -Padding "Default"
Add-AMElement -Card $card -Element $container_f30f6dab_8ddb_877b_001c_d350c0a03a53
$togglevisibility_ViewConversationHistory = New-AMToggleVisibilityAction -Title "View conversation history" -TargetElements @("ViewConversationHistoryWrapper", "ConversationWrapper", "ActionsWrapper")
$actionset_ViewConversationHistoryWrapper = New-AMActionSet -Id "ViewConversationHistoryWrapper" -Actions @($togglevisibility_ViewConversationHistory)
Add-AMElement -Card $card -Element $actionset_ViewConversationHistoryWrapper -ContainerId "f30f6dab-8ddb-877b-001c-d350c0a03a53"
$detailCard = @{
  'type' = 'AdaptiveCard'
  'body' = @(
    @{
      'type'        = "Input.Text"
      'id'          = "message"
      'placeholder' = "Type your reply here"
      'isMultiline' = $true
    },
    @{
      'type'    = "ActionSet"
      'id'      = "b86df692-99d9-8952-c1a7-d0cd0074934f"
      'actions' = @(
        @{
          'type'   = "Action.Http"
          'id'     = "3ae59121-cb90-1205-c5d0-77646ffe183b"
          'title'  = "Submit"
          'method' = "POST"
          'url'    = "https://www.microsoft.com"
          'body'   = "{Message: {{message.value}}}"
        }
      )
    }
  )
}
$showcard_caf22b50_33d3_2ea5_1b34_bcca0838bb33 = New-AMShowCardAction -Title "Reply to conversation" -Id "caf22b50-33d3-2ea5-1b34-bcca0838bb33" -Card $detailCard
$togglevisibility_11 = New-AMToggleVisibilityAction -Title "Go to conversation" -TargetElements @("ActionsWrapper", "ConversationWrapper", "ViewConversationHistoryWrapper")
$actionset_ActionsWrapper = New-AMActionSet -Id "ActionsWrapper" -Actions @($showcard_caf22b50_33d3_2ea5_1b34_bcca0838bb33, $togglevisibility_11)
Add-AMElement -Card $card -Element $actionset_ActionsWrapper -ContainerId "f30f6dab-8ddb-877b-001c-d350c0a03a53"
$container_d7214071_02c9_f3d3_242a_20b3b0fbef6a = New-AMContainer -Id "d7214071-02c9-f3d3-242a-20b3b0fbef6a" -Padding "Default"
Add-AMElement -Card $card -Element $container_d7214071_02c9_f3d3_242a_20b3b0fbef6a
$column_0_12 = New-AMColumn -Width "stretch" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Contoso_Logo.png" -AltText "Contoso Group Avatar" -Size "Medium")
)
$column_1_13 = New-AMColumn -Width "auto" -Items @(
    (New-AMTextBlock "[Privacy statement](https://amdesigner.azurewebsites.net)" -Size "Small" -Color "Light" -Wrap $true)
)
$columnset_e8c5b327_5a82_d7c5_b1c1_f653493ba321 = New-AMColumnSet -Id "e8c5b327-5a82-d7c5-b1c1-f653493ba321" -Columns @($column_0_12, $column_1_13)
Add-AMElement -Card $card -Element $columnset_e8c5b327_5a82_d7c5_b1c1_f653493ba321 -ContainerId "d7214071-02c9-f3d3-242a-20b3b0fbef6a"

# Export the card
$cardJson = Export-AMCard -Card $card


$mailParams = Export-AMCardForEmail -Card $card -Subject "Converstion history" -ToRecipients $userToSendTo -CreateGraphParams


Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/me/sendMail" -Body $mailParams





$jsonCard = get-content "Adaptive Cards in Outlook Sent from PowerShell/card2.json" -Raw

$card = ConvertFrom-AMJson -Json $jsonCard
$card

# Create a new card
$card = New-AMCard -OriginatorId "Replace-Me-With-Your-OriginatorId" -Version "1.0"

# Add elements to the card
$container_6343565f_52eb_c87b_c815_b772a86f1aca = New-AMContainer -Id "6343565f-52eb-c87b-c815-b772a86f1aca" -Style "emphasis" -Padding "Default"
Add-AMElement -Card $card -Element $container_6343565f_52eb_c87b_c815_b772a86f1aca
$textblock_d9c56323_fe1a_e090_1df5_311743b856cd = New-AMTextBlock -Text "Notification" -Wrap $true
Add-AMElement -Card $card -Element $textblock_d9c56323_fe1a_e090_1df5_311743b856cd -ContainerId "6343565f-52eb-c87b-c815-b772a86f1aca"
$container_03a273b0_e511_5f0d_3a44_1eddaa03a8a5 = New-AMContainer -Id "03a273b0-e511-5f0d-3a44-1eddaa03a8a5" -Padding "Default"
Add-AMElement -Card $card -Element $container_03a273b0_e511_5f0d_3a44_1eddaa03a8a5
$textblock_231d74e7_5c53_6ec8_102d_718dc936bc09 = New-AMTextBlock -Text "You have been mentioned in the conversation on Budget reports." -Size "Large" -Weight "Bolder" -Wrap $true
Add-AMElement -Card $card -Element $textblock_231d74e7_5c53_6ec8_102d_718dc936bc09 -ContainerId "03a273b0-e511-5f0d-3a44-1eddaa03a8a5"
$container_ConversationWrapper = New-AMContainer -Id "ConversationWrapper" -Padding "Default"
Add-AMElement -Card $card -Element $container_ConversationWrapper
$column_0 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Carlos_Slattery.png" -AltText "Rob Young Avatar" -Size "Small")
)
$column_1 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "Rob Young mentioned you" -Color "Light" -Wrap $true),
    (New-AMTextBlock "**@Kat Larsson** Can you check these numbers are accurate?" -Wrap $true)
)
$columnset_53fac03a_36e0_c77b_546a_01f4c727a73e = New-AMColumnSet -Id "53fac03a-36e0-c77b-546a-01f4c727a73e" -Columns @($column_0, $column_1)
Add-AMElement -Card $card -Element $columnset_53fac03a_36e0_c77b_546a_01f4c727a73e -ContainerId "ConversationWrapper"
$column_0_1 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Kat_Larsson.png" -AltText "Your Avatar" -Size "Small")
)
$column_1_2 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "You replied" -Color "Light" -Wrap $true),
    (New-AMTextBlock "**@Rob Young** I checked the numbers, they're accurate." -Wrap $true)
)
$columnset_73fac03a_36e0_c77b_546a_01f4c727a73e = New-AMColumnSet -Id "73fac03a-36e0-c77b-546a-01f4c727a73e" -Columns @($column_0_1, $column_1_2)
Add-AMElement -Card $card -Element $columnset_73fac03a_36e0_c77b_546a_01f4c727a73e -ContainerId "ConversationWrapper"
$column_0_3 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Colin_Ballinger.png" -AltText "Collin Ballinger Avatar" -Size "Small")
)
$column_1_4 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "Collin Ballinger mentioned Daisy Philips" -Color "Light" -Wrap $true),
    (New-AMTextBlock "**@Daisy Philips** Can you check these numbers are accurate?" -Wrap $true)
)
$columnset_76fac03a_36e0_c77b_546a_01f4c727a73e = New-AMColumnSet -Id "76fac03a-36e0-c77b-546a-01f4c727a73e" -Columns @($column_0_3, $column_1_4)
Add-AMElement -Card $card -Element $columnset_76fac03a_36e0_c77b_546a_01f4c727a73e -ContainerId "ConversationWrapper"
$column_0_5 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Daisy_Phillips.png" -AltText "Daisy Philips Avatar" -Size "Small")
)
$column_1_6 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "Daisy Philips left a comment" -Color "Light" -Wrap $true),
    (New-AMTextBlock "**@Collin Ballinger** I think it looks fine." -Wrap $true),
    (New-AMTextBlock "8 more replies" -Color "Accent" -Wrap $true)
)
$columnset_76fac3a_36e0_c77b_546a_01f4c727a73e = New-AMColumnSet -Id "76fac3a-36e0-c77b-546a-01f4c727a73e" -Columns @($column_0_5, $column_1_6)
Add-AMElement -Card $card -Element $columnset_76fac3a_36e0_c77b_546a_01f4c727a73e -ContainerId "ConversationWrapper"
$column_0_7 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Colin_Ballinger.png" -AltText "Collin Ballinger Avatar" -Size "Small")
)
$column_1_8 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "Collin Ballinger left a comment" -Color "Light" -Wrap $true),
    (New-AMTextBlock "I think we need to hear from Kat." -Wrap $true)
)
$columnset_76fac3a_c77b_546a_01f4c727a73e = New-AMColumnSet -Id "76fac3a-c77b-546a-01f4c727a73e" -Columns @($column_0_7, $column_1_8)
Add-AMElement -Card $card -Element $columnset_76fac3a_c77b_546a_01f4c727a73e -ContainerId "ConversationWrapper"
$container_5db09e08_ae3d_95a8_6562_8e0a4682fcb1 = New-AMContainer -Id "5db09e08-ae3d-95a8-6562-8e0a4682fcb1" -Style "emphasis" -Padding "Default"
Add-AMElement -Card $card -Element $container_5db09e08_ae3d_95a8_6562_8e0a4682fcb1
$column_0_9 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Daisy_Phillips.png" -AltText "Daisy Philips Avatar" -Size "Small")
)
$column_1_10 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "Daisy Philips mentioned you" -Color "Light" -Wrap $true),
    (New-AMTextBlock "**@Kat Larsson** We do need to proceed ASAP to unblock the Dev team." -Wrap $true)
)
$columnset_54fac03a_36e0_c77b_546a_01f4c727a73e = New-AMColumnSet -Id "54fac03a-36e0-c77b-546a-01f4c727a73e" -Columns @($column_0_9, $column_1_10)
Add-AMElement -Card $card -Element $columnset_54fac03a_36e0_c77b_546a_01f4c727a73e -ContainerId "5db09e08-ae3d-95a8-6562-8e0a4682fcb1"
$container_f30f6dab_8ddb_877b_001c_d350c0a03a53 = New-AMContainer -Id "f30f6dab-8ddb-877b-001c-d350c0a03a53" -Padding "Default"
Add-AMElement -Card $card -Element $container_f30f6dab_8ddb_877b_001c_d350c0a03a53
$togglevisibility_ViewConversationHistory = New-AMToggleVisibilityAction -Title "View conversation history" -TargetElements @("ViewConversationHistoryWrapper", "ConversationWrapper", "ActionsWrapper")
$actionset_ViewConversationHistoryWrapper = New-AMActionSet -Id "ViewConversationHistoryWrapper" -Actions @($togglevisibility_ViewConversationHistory)
Add-AMElement -Card $card -Element $actionset_ViewConversationHistoryWrapper -ContainerId "f30f6dab-8ddb-877b-001c-d350c0a03a53"
$detailCard = @{
  'type' = 'AdaptiveCard'
  'body' = @(
    @{
      'type'        = "Input.Text"
      'id'          = "message"
      'placeholder' = "Type your reply here"
      'isMultiline' = $true
    },
    @{
      'type'    = "ActionSet"
      'id'      = "b86df692-99d9-8952-c1a7-d0cd0074934f"
      'actions' = @(
        @{
          'type'   = "Action.Http"
          'id'     = "3ae59121-cb90-1205-c5d0-77646ffe183b"
          'title'  = "Submit"
          'method' = "POST"
          'url'    = "https://www.microsoft.com"
          'body'   = "{Message: {{message.value}}}"
        }
      )
    }
  )
}
$showcard_caf22b50_33d3_2ea5_1b34_bcca0838bb33 = New-AMShowCardAction -Title "Reply to conversation" -Id "caf22b50-33d3-2ea5-1b34-bcca0838bb33" -Card $detailCard
$togglevisibility_11 = New-AMToggleVisibilityAction -Title "Go to conversation" -TargetElements @("ActionsWrapper", "ConversationWrapper", "ViewConversationHistoryWrapper")
$actionset_ActionsWrapper = New-AMActionSet -Id "ActionsWrapper" -Actions @($showcard_caf22b50_33d3_2ea5_1b34_bcca0838bb33, $togglevisibility_11)
Add-AMElement -Card $card -Element $actionset_ActionsWrapper -ContainerId "f30f6dab-8ddb-877b-001c-d350c0a03a53"
$container_d7214071_02c9_f3d3_242a_20b3b0fbef6a = New-AMContainer -Id "d7214071-02c9-f3d3-242a-20b3b0fbef6a" -Padding "Default"
Add-AMElement -Card $card -Element $container_d7214071_02c9_f3d3_242a_20b3b0fbef6a
$column_0_12 = New-AMColumn -Width "stretch" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Contoso_Logo.png" -AltText "Contoso Group Avatar" -Size "Medium")
)
$column_1_13 = New-AMColumn -Width "auto" -Items @(
    (New-AMTextBlock "[Privacy statement](https://amdesigner.azurewebsites.net)" -Size "Small" -Color "Light" -Wrap $true)
)
$columnset_e8c5b327_5a82_d7c5_b1c1_f653493ba321 = New-AMColumnSet -Id "e8c5b327-5a82-d7c5-b1c1-f653493ba321" -Columns @($column_0_12, $column_1_13)
Add-AMElement -Card $card -Element $columnset_e8c5b327_5a82_d7c5_b1c1_f653493ba321 -ContainerId "d7214071-02c9-f3d3-242a-20b3b0fbef6a"

# Export the card
$cardJson = Export-AMCard -Card $card

PS C:\temp\GlobalAzureDerbyPowerShellUKGathering2025>
PS C:\temp\GlobalAzureDerbyPowerShellUKGathering2025> $jsonCard = get-content "Adaptive Cards in Outlook Sent from PowerShell/card2.json" -Raw

$card = ConvertFrom-AMJson -Json $jsonCard
$card
# Create a new card
$card = New-AMCard -OriginatorId "Replace-Me-With-Your-OriginatorId" -Version "1.0"

# Add elements to the card
$container_1 = New-AMContainer -Style "emphasis" -Padding "Default"
Add-AMElement -Card $card -Element $container_1
$column_0 = New-AMColumn -Width "stretch" -Items @(
    (New-AMTextBlock "Event Feedback")
)
$column_1 = New-AMColumn -Width "auto" -Items @(
    (New-AMImage -Url "https://amdesigner.azurewebsites.net/samples/assets/Contoso_Logo.png" -AltText "Contoso Group Avatar")
)
$columnset_2 = New-AMColumnSet -Id "columnset_2" -Columns @($column_0, $column_1)
Add-AMElement -Card $card -Element $columnset_2
$container_3 = New-AMContainer -Padding "Default"
Add-AMElement -Card $card -Element $container_3
$textblock_4 = New-AMTextBlock -Text "Help us improve by taking our short satisfaction survey." -Size "Large" -Weight "Bolder" -Wrap $true
Add-AMElement -Card $card -Element $textblock_4
$container_5 = New-AMContainer -Padding "Custom" -CustomPadding @{top = "Small"; right = "Default"; left = "Default"; bottom = "Default" }
Add-AMElement -Card $card -Element $container_5
$textblock_6 = New-AMTextBlock -Text "1\. How likely is that you would recommend the event to a friend or colleague?" -Weight "Bolder" -Wrap $true
Add-AMElement -Card $card -Element $textblock_6
$choices = @(
    (New-AMChoice -Title "1" -Value "1"),
    (New-AMChoice -Title "2" -Value "2"),
    (New-AMChoice -Title "3" -Value "3"),
    (New-AMChoice -Title "4" -Value "4"),
    (New-AMChoice -Title "5" -Value "5")
)
$choiceset_Recommendation = New-AMChoiceSetInput -Id "Recommendation" -Label "How likely is that you would recommend the event to a friend or colleague? Please select an item in the list" -IsMultiSelect $false -Choices $choices
Add-AMElement -Card $card -Element $choiceset_Recommendation
$textblock_7 = New-AMTextBlock -Text "2\. Overall, how would you rate the event?" -Weight "Bolder" -Wrap $true
Add-AMElement -Card $card -Element $textblock_7
$choices = @(
    (New-AMChoice -Title "Excellent" -Value "Excellent"),
    (New-AMChoice -Title "Very Good" -Value "Very Good"),
    (New-AMChoice -Title "Good" -Value "Good"),
    (New-AMChoice -Title "Fair" -Value "Fair"),
    (New-AMChoice -Title "Poor" -Value "Poor")
)
$choiceset_OverallRating = New-AMChoiceSetInput -Id "OverallRating" -Label "Overall, how would you rate the event?" -Style "expanded" -IsMultiSelect $false -Choices $choices
Add-AMElement -Card $card -Element $choiceset_OverallRating
$textblock_8 = New-AMTextBlock -Text "3\. What did you like about the event?" -Weight "Bolder" -Wrap $true
Add-AMElement -Card $card -Element $textblock_8
$text_Comment = New-AMTextInput -Id "Comment" -Label "What did you like about the event?" -Placeholder "Tell us everything" -IsMultiline $true
Add-AMElement -Card $card -Element $text_Comment
$textblock_9 = New-AMTextBlock -Text "4\. When were you informed about the event?" -Weight "Bolder" -Wrap $true
Add-AMElement -Card $card -Element $textblock_9
$date_InformedDate = New-AMDateInput -Id "InformedDate" -Label "When were you informed about the event?"
Add-AMElement -Card $card -Element $date_InformedDate
$textblock_10 = New-AMTextBlock -Text "5\. How would you describe the event?" -Weight "Bolder" -Wrap $true
Add-AMElement -Card $card -Element $textblock_10
$choices = @(
    (New-AMChoice -Title "Organized" -Value "Organized"),
    (New-AMChoice -Title "Enjoyable" -Value "Enjoyable"),
    (New-AMChoice -Title "Informative" -Value "Informative"),
    (New-AMChoice -Title "Relevant" -Value "Relevant"),
    (New-AMChoice -Title "Social" -Value "Social")
)
$choiceset_Feeling = New-AMChoiceSetInput -Id "Feeling" -Label "How would you describe the event?" -Style "expanded" -IsMultiSelect $True -Choices $choices
Add-AMElement -Card $card -Element $choiceset_Feeling
$http_12 = New-AMExecuteAction -Title "Submit" -Verb "POST" -Url "https://actionsplayground.azurewebsites.net/workspaces/IREXSqpHRk-hkfa7y7CAAw" -Body '{`"Recommendation`": `"{{Recommendation.value}}`", `"OverallRating`":`"{{OverallRating.value}}`", `"Comment`":`"{{Comment.value}}`",
`"InformedDate`":`"{{InformedDate.value}}`", `"Feeling`":`"{{Feeling.value}}`" }' -IsPrimary $true
$actionset_11 = New-AMActionSet -Actions @($http_12)
Add-AMElement -Card $card -Element $actionset_11

# Export the card
$cardJson = Export-AMCard -Card $card

$mailParams = Export-AMCardForEmail -Card $card -Subject "Event Feedback" -ToRecipients $userToSendTo -CreateGraphParams

Invoke-MgGraphRequest -Method POST -Uri "https://graph.microsoft.com/v1.0/me/sendMail" -Body $mailParams