
Write-Output "setup using:"
# Open internet browser on "https://amdesigner.azurewebsites.net/"
Write-Output "https://amdesigner.azurewebsites.net/"

$jsonCardExample = @"
{
    "`$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
    "type": "AdaptiveCard",
    "version": "1.0",
    "body": [
        {
            "type": "Container",
            "id": "34eadec9-ac74-5c77-3e62-875a8b9c5f3c",
            "padding": "Small",
            "items": [
                {
                    "type": "ColumnSet",
                    "id": "fedae9ca-c2d5-5dd2-4a59-176681872822",
                    "columns": [
                        {
                            "type": "Column",
                            "id": "e6d9a897-f9e4-067b-52da-c9900c83e886",
                            "padding": "None",
                            "width": "auto",
                            "items": [
                                {
                                    "type": "Image",
                                    "id": "0f1bd522-ef75-3f9f-14c4-4ef9e234721f",
                                    "url": "https://amdesigner.azurewebsites.net/samples/assets/PlaceHolder_Person.png",
                                    "size": "Small",
                                    "altText": "Contoso Group Avatar"
                                }
                            ]
                        },
                        {
                            "type": "Column",
                            "id": "b48b0ab2-4c13-5b59-88eb-2fc97c943d39",
                            "padding": "None",
                            "width": "stretch",
                            "items": [
                                {
                                    "type": "TextBlock",
                                    "id": "2d13ea41-2866-7130-44de-4a18d3093cf7",
                                    "text": "Contoso Group",
                                    "wrap": true
                                },
                                {
                                    "type": "TextBlock",
                                    "id": "05758164-9a44-9484-5ee6-c91f248993d5",
                                    "text": "Private Group",
                                    "wrap": true,
                                    "spacing": "None",
                                    "color": "Light",
                                    "size": "Small"
                                }
                            ],
                            "verticalContentAlignment": "Center"
                        }
                    ],
                    "padding": "None"
                }
            ],
            "spacing": "None",
            "style": "emphasis"
        },
        {
            "type": "Container",
            "id": "0bdaded9-7b2d-fb8b-c298-ac819fd31288",
            "padding": "Default",
            "spacing": "None",
            "items": [
                {
                    "type": "TextBlock",
                    "id": "50c52578-8e51-1512-aeb1-5a714e8b460b",
                    "text": "Elvia Atkins would like to add 3 members to your group.",
                    "wrap": true,
                    "size": "Large",
                    "weight": "Bolder",
                    "style": "heading"
                }
            ],
            "separator": true
        },
        {
            "type": "Container",
            "id": "47295af6-a6b8-fd4f-f90f-018d01f8e130",
            "padding": "Default",
            "spacing": "None",
            "items": [
                {
                    "type": "TextBlock",
                    "id": "3f5e8bb4-217c-ab02-0c24-097aa57151eb",
                    "text": "Select the requests you want to approve or decline.",
                    "wrap": true,
                    "spacing": "None",
                    "size": "Small"
                },
                {
                    "type": "ColumnSet",
                    "id": "a1e100d4-32eb-23a2-1efe-ee427dabbc61",
                    "columns": [
                        {
                            "type": "Column",
                            "id": "9a761dbd-9793-09ce-eb6e-0009f96713c0",
                            "padding": {
                                "top": "Small",
                                "bottom": "None",
                                "left": "None",
                                "right": "None"
                            },
                            "width": "auto",
                            "items": [
                                {
                                    "type": "Input.Toggle",
                                    "id": "Select1",
                                    "title": " ",
                                    "value": "false",
                                    "wrap": false,
                                    "label": "Miguel Garcia Program Manager Oslo-O365"
                                }
                            ],
                            "spacing": "None"
                        },
                        {
                            "type": "Column",
                            "id": "5be4e78f-0516-88b9-3c8a-aaa4a363c891",
                            "padding": "None",
                            "width": "auto",
                            "spacing": "None",
                            "items": [
                                {
                                    "type": "Image",
                                    "id": "dbb6d6c-92de-3847-c52c-19b50a2b1e35",
                                    "url": "https://amdesigner.azurewebsites.net/samples/assets/Miguel_Garcia.png",
                                    "spacing": "None",
                                    "size": "Small",
                                    "style": "Person",
                                    "altText": "Miguel Garcia Avatar"
                                }
                            ]
                        },
                        {
                            "type": "Column",
                            "id": "bc3069ca-e365-0acb-825a-d0088fde0017",
                            "padding": "None",
                            "width": "stretch",
                            "spacing": "Small",
                            "items": [
                                {
                                    "type": "TextBlock",
                                    "id": "6a77917-41b7-7959-2d35-bb5f1bfc1a97",
                                    "text": "Miguel Garcia",
                                    "wrap": true
                                },
                                {
                                    "type": "TextBlock",
                                    "id": "38552ef-2a05-e130-d308-456843e0e74d",
                                    "text": "Program Manager",
                                    "wrap": true,
                                    "spacing": "None",
                                    "size": "Small",
                                    "color": "Light"
                                },
                                {
                                    "type": "TextBlock",
                                    "id": "a176e77-f0ac-15dc-377a-ed3f80302fa6",
                                    "text": "Oslo-O365",
                                    "wrap": true,
                                    "size": "Small",
                                    "color": "Light",
                                    "spacing": "None"
                                },
                                {
                                    "type": "TextBlock",
                                    "id": "9d1870b-42a3-b0d9-85bd-0c1275085158",
                                    "text": "*\"Please add me. I am new to the team.\"*",
                                    "wrap": true,
                                    "spacing": "Small",
                                    "size": "Small"
                                }
                            ]
                        }
                    ],
                    "padding": "None"
                },
                {
                    "type": "ColumnSet",
                    "id": "e100d4-32eb-23a2-1efe-ee427dabbc61",
                    "padding": "None",
                    "columns": [
                        {
                            "type": "Column",
                            "id": "a761dbd-9793-09ce-eb6e-0009f96713c0",
                            "padding": {
                                "top": "Small",
                                "bottom": "None",
                                "left": "None",
                                "right": "None"
                            },
                            "width": "auto",
                            "spacing": "None",
                            "items": [
                                {
                                    "type": "Input.Toggle",
                                    "id": "Select2",
                                    "title": " ",
                                    "value": "false",
                                    "wrap": false,
                                    "label": "Daisy Phillips Program Manager II Oslo-O365"
                                }
                            ]
                        },
                        {
                            "type": "Column",
                            "id": "be4e78f-0516-88b9-3c8a-aaa4a363c891",
                            "padding": "None",
                            "width": "auto",
                            "spacing": "None",
                            "items": [
                                {
                                    "type": "Image",
                                    "id": "b6d6c-92de-3847-c52c-19b50a2b1e35",
                                    "url": "https://amdesigner.azurewebsites.net/samples/assets/Daisy_Phillips.png",
                                    "spacing": "None",
                                    "size": "Small",
                                    "style": "Person",
                                    "altText": "Daisy Phillips Avatar"
                                }
                            ]
                        },
                        {
                            "type": "Column",
                            "id": "c3069ca-e365-0acb-825a-d0088fde0017",
                            "padding": "None",
                            "width": "stretch",
                            "spacing": "Small",
                            "items": [
                                {
                                    "type": "TextBlock",
                                    "id": "77917-41b7-7959-2d35-bb5f1bfc1a97",
                                    "text": "Daisy Phillips",
                                    "wrap": true
                                },
                                {
                                    "type": "TextBlock",
                                    "id": "552ef-2a05-e130-d308-456843e0e74d",
                                    "text": "Program Manager II",
                                    "wrap": true,
                                    "spacing": "None",
                                    "size": "Small",
                                    "color": "Light"
                                },
                                {
                                    "type": "TextBlock",
                                    "id": "76e77-f0ac-15dc-377a-ed3f80302fa6",
                                    "text": "Oslo-O365",
                                    "wrap": true,
                                    "size": "Small",
                                    "color": "Light",
                                    "spacing": "None"
                                },
                                {
                                    "type": "TextBlock",
                                    "id": "1870b-42a3-b0d9-85bd-0c1275085158",
                                    "text": "*\"Please add me. I am new to the team.\"*",
                                    "wrap": true,
                                    "spacing": "Small",
                                    "size": "Small"
                                }
                            ]
                        }
                    ]
                },
                {
                    "type": "ColumnSet",
                    "id": "00d4-32eb-23a2-1efe-ee427dabbc61",
                    "padding": "None",
                    "columns": [
                        {
                            "type": "Column",
                            "id": "61dbd-9793-09ce-eb6e-0009f96713c0",
                            "padding": {
                                "top": "Small",
                                "bottom": "None",
                                "left": "None",
                                "right": "None"
                            },
                            "width": "auto",
                            "spacing": "None",
                            "items": [
                                {
                                    "type": "Input.Toggle",
                                    "id": "Select3",
                                    "title": " ",
                                    "value": "false",
                                    "wrap": false,
                                    "label": "Kat Larsson Senior Design Manager Redmond B-3"
                                }
                            ]
                        },
                        {
                            "type": "Column",
                            "id": "4e78f-0516-88b9-3c8a-aaa4a363c891",
                            "padding": "None",
                            "width": "auto",
                            "spacing": "None",
                            "items": [
                                {
                                    "type": "Image",
                                    "id": "6d6c-92de-3847-c52c-19b50a2b1e35",
                                    "url": "https://amdesigner.azurewebsites.net/samples/assets/Kat_Larsson.png",
                                    "spacing": "None",
                                    "size": "Small",
                                    "style": "Person",
                                    "altText": "Kat Larsson Avatar"
                                }
                            ]
                        },
                        {
                            "type": "Column",
                            "id": "069ca-e365-0acb-825a-d0088fde0017",
                            "padding": "None",
                            "width": "stretch",
                            "spacing": "Small",
                            "items": [
                                {
                                    "type": "TextBlock",
                                    "id": "7917-41b7-7959-2d35-bb5f1bfc1a97",
                                    "text": "Kat Larsson",
                                    "wrap": true
                                },
                                {
                                    "type": "TextBlock",
                                    "id": "52ef-2a05-e130-d308-456843e0e74d",
                                    "text": "Senior Design Manager",
                                    "wrap": true,
                                    "spacing": "None",
                                    "size": "Small",
                                    "color": "Light"
                                },
                                {
                                    "type": "TextBlock",
                                    "id": "6e77-f0ac-15dc-377a-ed3f80302fa6",
                                    "text": "Redmond B-3",
                                    "wrap": true,
                                    "size": "Small",
                                    "color": "Light",
                                    "spacing": "None"
                                },
                                {
                                    "type": "TextBlock",
                                    "id": "870b-42a3-b0d9-85bd-0c1275085158",
                                    "text": "*\"Please add me to this group. I will be working with the development and design team from now on and being part of this group would be helpful\"*",
                                    "wrap": true,
                                    "spacing": "Small",
                                    "size": "Small"
                                }
                            ]
                        }
                    ]
                },
                {
                    "type": "ActionSet",
                    "id": "cabbf18e-fa8c-ff66-e2d9-6626bb1b841e",
                    "actions": [
                        {
                            "type": "Action.Http",
                            "id": "7e6a701f-815f-2a67-4af1-a316b59c8e83",
                            "title": "Approve Selected",
                            "method": "POST",
                            "url": "https://www.microsoft.com",
                            "body": "{Member1: {{Select1.value}}, Member2: {{Select2.value}},\nMember3: {{Select3.value}}}",
                            "isPrimary": true,
                            "style": "positive"
                        },
                        {
                            "type": "Action.Http",
                            "id": "8fc07b67-9628-9ad6-089d-c4ded8be9e23",
                            "title": "Decline Selected",
                            "method": "POST",
                            "url": "https://www.microsoft.com",
                            "body": "{Member1: {{Select1.value}}, Member2: {{Select2.value}},\nMember3: {{Select3.value}}}"
                        }
                    ]
                }
            ],
            "separator": true
        }
    ],
    "padding": "None",
    "type": "AdaptiveCard",
    "@context": "http://schema.org/extensions"
}
"@

# convert to the powershell module cmdlets
$card = ConvertFrom-AMJson -Json $jsonCardExample
Write-Output "Card converted to PowerShell module cmdlets"
# output the card to a new file
$card | Out-File -FilePath "2025/ActionableMessages - PSUG InnSalzach/CardExample.ps1"
