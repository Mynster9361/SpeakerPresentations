<# Checking out some of the prebuilt cards
This script is used to check out some of the prebuilt Actionable Message cards.

New-AMAccountVerificationCard

New-AMApplicationUsageSurveyCard

New-AMApprovalCard

New-AMDiskSpaceAlertCard

New-AMITResourceRequestCard

New-AMNotificationCard

New-AMServerMonitoringCard

New-AMServerPurposeSurveyCard

New-AMServiceAlertCard

get-help cmd -Full

#>

$accountCardParams = @{
  OriginatorId      = "your-originator-id"
  Username          = "jsmith"
  AccountOwner      = "John Smith"
  Department        = "Marketing"
  LastLoginDate     = (Get-Date).AddDays(-120)
  InactiveDays      = 120
  AccessibleSystems = @("CRM System", "Marketing Automation", "Document Repository")
  TicketNumber      = "ACC-2023-001"
  DisableDate       = (Get-Date).AddDays(14)
  DisableText       = "This account has been identified as inactive."
  StatusChoices     = @{
    "keep"            = "Account is still needed and actively used"
    "keep-infrequent" = "Account is needed but used infrequently"
    "disable"         = "Account can be disabled"
    "transfer"        = "Account needs to be transferred to another user"
    "unknown"         = "I don't know / Need more information"
  }
  ResponseEndpoint  = "https://api.example.com/account-verification"
  ResponseBody      = "{`"ticketNumber`": `"$TicketNumber`", `"username`": `"$Username`", `"accountStatus`": `"{{account-status.value}}`", `"comment`": `"{{comment.value}}`", `"transferTo`": `"{{transfer-to.value}}`}"
}

$accountCard = New-AMAccountVerificationCard @accountCardParams

Show-AMCardPreview -card $accountCard

Export-AMCard -Card $accountCard

<#
get-help New-AMAccountVerificationCard -Full

NAME
    New-AMAccountVerificationCard

SYNOPSIS
    Creates an Adaptive Card for account verification.


SYNTAX
    New-AMAccountVerificationCard [[-OriginatorId] <String>] [-Username] <String> [[-AccountOwner] <String>] [[-Department] <String>] [[-LastLoginDate] <DateTime>] [[-InactiveDays] <Int32>] [[-AccessibleSystems] <String[]>] [[-TicketNumber]
    <String>] [[-DisableDate] <DateTime>] [[-DisableText] <String>] [[-statusChoices] <Object>] [[-ResponseEndpoint] <String>] [[-ResponseBody] <String>] [<CommonParameters>]


DESCRIPTION
    The `New-AMAccountVerificationCard` function generates an Adaptive Card to notify users about an account that requires verification.
    The card includes details about the account, its owner, department, last login, and systems the account has access to.
    It also provides options for the user to confirm, disable, or transfer the account, along with a comment field for additional input.


PARAMETERS
    -OriginatorId <String>
        The originator ID of the card. This is used to identify the source of the card. Defaults to "your-originator-id".

        Required?                    false
        Position?                    1
        Default value                your-originator-id
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    -Username <String>
        The username of the account being verified.

        Required?                    true
        Position?                    2
        Default value
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    -AccountOwner <String>
        (Optional) The name of the account owner.

        Required?                    false
        Position?                    3
        Default value
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    -Department <String>
        (Optional) The department associated with the account.

        Required?                    false
        Position?                    4
        Default value
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    -LastLoginDate <DateTime>
        (Optional) The date and time of the last login for the account.

        Required?                    false
        Position?                    5
        Default value
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    -InactiveDays <Int32>
        (Optional) The number of days the account has been inactive. Defaults to 90 days.

        Required?                    false
        Position?                    6
        Default value                90
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    -AccessibleSystems <String[]>
        (Optional) A list of systems the account has access to.

        Required?                    false
        Position?                    7
        Default value
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    -TicketNumber <String>
        (Optional) The ticket number associated with the account verification request.

        Required?                    false
        Position?                    8
        Default value
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    -DisableDate <DateTime>
        (Optional) The date when the account will be disabled if no response is received.

        Required?                    false
        Position?                    9
        Default value
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    -DisableText <String>
        (Optional) The text displayed to describe the reason for the account verification. Defaults to a predefined message.

        Required?                    false
        Position?                    10
        Default value                This account has been identified as inactive. Please respond to this notification to confirm if this account is still required. If no response is received, the account may be disabled as part of our
        security protocols.
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    -statusChoices <Object>
        (Optional) A hashtable of status choices for the account. Each key-value pair represents an option and its description.
        Defaults to:
            @{
                "keep" = "Account is still needed and actively used"
                "keep-infrequent" = "Account is needed but used infrequently"
                "disable" = "Account can be disabled"
                "transfer" = "Account needs to be transferred to another user"
                "unknown" = "I don't know / Need more information"
            }

        Required?                    false
        Position?                    11
        Default value                [ordered]@{
                    "keep"            = "Account is still needed and actively used"
                    "keep-infrequent" = "Account is needed but used infrequently"
                    "disable"         = "Account can be disabled"
                    "transfer"        = "Account needs to be transferred to another user"
                    "unknown"         = "I don't know / Need more information"
                }
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    -ResponseEndpoint <String>
        (Optional) The URL where the response will be sent. Defaults to "https://api.example.com/account-verification".

        Required?                    false
        Position?                    12
        Default value                https://api.example.com/account-verification
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    -ResponseBody <String>
        (Optional) The body of the POST request sent to the `ResponseEndpoint`.
        This is a JSON string that includes placeholders for dynamic values such as the ticket number, username, account status, comments, and transfer details.
        Defaults to:
            "{`"ticketNumber`": `"$TicketNumber`", `"username`": `"$Username`", `"accountStatus`": `"{{account-status.value}}`", `"comment`": `"{{comment.value}}`", `"transferTo`": `"{{transfer-to.value}}`}"

        Required?                    false
        Position?                    13
        Default value                "{`"ticketNumber`": `"$TicketNumber`", `"username`": `"$Username`", `"accountStatus`": `"{{account-status.value}}`", `"comment`": `"{{comment.value}}`", `"transferTo`": `"{{transfer-to.value}}`}"
        Accept pipeline input?       false
        Aliases
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (https://go.microsoft.com/fwlink/?LinkID=113216).

INPUTS

OUTPUTS

NOTES


        This function is part of the Actionable Messages module and is used to create Adaptive Cards for account verification.
        The card can be exported and sent via email or other communication channels.

    -------------------------- EXAMPLE 1 --------------------------

    PS > # Example 1: Create an account verification card using splatting
    $accountCardParams = @{
        OriginatorId       = "your-originator-id"
        Username           = "jsmith"
        AccountOwner       = "John Smith"
        Department         = "Marketing"
        LastLoginDate      = (Get-Date).AddDays(-120)
        InactiveDays       = 120
        AccessibleSystems  = @("CRM System", "Marketing Automation", "Document Repository")
        TicketNumber       = "ACC-2023-001"
        DisableDate        = (Get-Date).AddDays(14)
        DisableText        = "This account has been identified as inactive."
        StatusChoices      = @{
            "keep" = "Account is still needed and actively used"
            "keep-infrequent" = "Account is needed but used infrequently"
            "disable" = "Account can be disabled"
            "transfer" = "Account needs to be transferred to another user"
            "unknown" = "I don't know / Need more information"
        }
        ResponseEndpoint   = "https://api.example.com/account-verification"
        ResponseBody       = "{`"ticketNumber`": `"$TicketNumber`", `"username`": `"$Username`", `"accountStatus`": `"{{account-status.value}}`", `"comment`": `"{{comment.value}}`", `"transferTo`": `"{{transfer-to.value}}`}"
    }

    $accountCard = New-AMAccountVerificationCard @accountCardParams




    -------------------------- EXAMPLE 2 --------------------------

    PS > # Example 2: Create a simple account verification card using splatting
    $simpleAccountCardParams = @{
        OriginatorId       = "account-verification-system"
        Username           = "asmith"
        AccountOwner       = "Alice Smith"
        LastLoginDate      = (Get-Date).AddDays(-60)
        InactiveDays       = 60
        ResponseEndpoint   = "https://api.example.com/account-verification"
        ResponseBody       = "{`"ticketNumber`": `"$TicketNumber`", `"username`": `"$Username`", `"accountStatus`": `"{{account-status.value}}`", `"comment`": `"{{comment.value}}`", `"transferTo`": `"{{transfer-to.value}}`}"
    }

    $accountCard = New-AMAccountVerificationCard @simpleAccountCardParams





RELATED LINKS
#>
