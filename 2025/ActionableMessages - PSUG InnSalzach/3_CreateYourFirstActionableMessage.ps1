

# Creating the container/card for the actionable message

$card = New-AMCard -OriginatorId "Replace-Me-With-Your-OriginatorId"

# Add elements to the card
$textBlock = New-AMTextBlock -Card $card -Text "Hello, this is a test message."

Add-AMElement -Card $card -Element $textBlock

# show the card
Show-AMCardPreview -card $card

# Additional elements can be added to the card as needed
# For example, adding a button
$button = New-AMOpenUrlAction -Title "Visit My blog" -Url "https://mynster9361.github.io/"

$actionSet = New-AMActionSet -Actions @($button)
Add-AMElement -Card $card -Element $actionSet

# Show the updated card with the button
Show-AMCardPreview -card $card


# Another way to go about it is creating the action within the actions instead

$actionSet = New-AMActionSet -Actions @(
  $(New-AMOpenUrlAction -Title "Visit My blog" -Url "https://mynster9361.github.io/")
)

Add-AMElement -Card $card -Element $actionSet
# Lets export it and view it on the designer
Export-AMCard -Card $card

# The same can be done for factsets, choicesets and images

$fact1 = New-AMFact -Title "Fact Title" -Value "Fact Value"
$fact2 = New-AMFact -Title "Another Fact" -Value "Another Value"
$factSet = New-AMFactSet -Facts @($fact1, $fact2)
Add-AMElement -Card $card -Element $factSet

Export-AMCard -Card $card

# choiceset example
$choice1 = New-AMChoice -Title "Choice 1" -Value "Value1"
$choice2 = New-AMChoice -Title "Choice 2" -Value "Value2"
$choiceSet = New-AMChoiceSetInput -Id "myChoiceSet" -Choices @($choice1, $choice2) -Style "expanded"
Add-AMElement -Card $card -Element $choiceSet

Export-AMCard -Card $card

# Images
$image = New-AMImage -Url "https://example.com/image.png" -AltText "Example Image" -Size "Medium"
Add-AMElement -Card $card -Element $image

# Image set
$image1 = New-AMImage -Url "https://example.com/image1.png" -AltText "Image 1" -Size "Small"
$image2 = New-AMImage -Url "https://example.com/image2.png" -AltText "Image 2" -Size "Small"
$imageSet = New-AMImageSet -Images  @($image1, $image2)
Add-AMElement -Card $card -Element $imageSet

Export-AMCard -Card $card
