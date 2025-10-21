#region Introduction to API HTTP Methods
<#
HTTP Methods are standardized ways to interact with resources via APIs:
- GET: Retrieve data
- POST: Create new data
- PUT: Update existing data (replace entire resource)
- PATCH: Partially update data
- DELETE: Remove data
#>
#endregion

#region GET Example - Retrieving Data
# GET Example: Retrieve a list of users from a fictional API
# DOCS: https://jsonplaceholder.typicode.com/guide/
try {
    $response = Invoke-RestMethod -Uri "https://jsonplaceholder.typicode.com/users" -Method GET
    Write-Host "Successfully retrieved $(($response).Count) users" -ForegroundColor Green

    # Display the first user
    Write-Host "First user:" -ForegroundColor Yellow
    $response[0] | Format-List
}
catch {
    Write-Host "Error making GET request: $_" -ForegroundColor Red
}
#endregion

#region POST Example - Creating Data
# POST Example: Create a new user

$newUser = @{
    name    = "John Doe"
    email   = "john.doe@example.com"
    phone   = "555-1234"
    website = "johndoe.com"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://jsonplaceholder.typicode.com/users" -Method POST -Body $newUser -ContentType "application/json"
    Write-Host "Successfully created user with ID: $($response.id)" -ForegroundColor Green
    $response | Format-List
}
catch {
    Write-Host "Error making POST request: $_" -ForegroundColor Red
}
#endregion

#region PUT Example - Updating Data
# PUT Example: Update an existing user

$updatedUser = @{
    id      = 1
    name    = "John Smith"
    email   = "john.smith@example.com"
    phone   = "555-5678"
    website = "johnsmith.com"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://jsonplaceholder.typicode.com/users/1" -Method PUT -Body $updatedUser -ContentType "application/json"
    Write-Host "Successfully updated user with ID: $($response.id)" -ForegroundColor Green
    $response | Format-List
}
catch {
    Write-Host "Error making PUT request: $_" -ForegroundColor Red
}
#endregion

#region DELETE Example - Removing Data
# DELETE Example: Delete a user

try {
    $response = Invoke-RestMethod -Uri "https://jsonplaceholder.typicode.com/users/1" -Method DELETE
    Write-Host "Successfully deleted user" -ForegroundColor Green

    # JSONPlaceholder API typically returns an empty object on successful DELETE
    if ($null -eq $response -or ($response | Get-Member).Count -eq 4) {
        Write-Host "Resource was deleted (empty response)" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Error making DELETE request: $_" -ForegroundColor Red
}
#endregion

#region PATCH Example - Partial Updates
# PATCH Example: Partially update a user

$partialUpdate = @{
    email = "new.email@example.com"
} | ConvertTo-Json

try {
    $response = Invoke-RestMethod -Uri "https://jsonplaceholder.typicode.com/users/1" -Method PATCH -Body $partialUpdate -ContentType "application/json"
    Write-Host "Successfully patched user with ID: $($response.id)" -ForegroundColor Green
    $response | Format-List
}
catch {
    Write-Host "Error making PATCH request: $_" -ForegroundColor Red
}
#endregion
