#region Basic API Call
# The simplest API call - no authentication
try {
    $response = Invoke-RestMethod -Uri "https://api.energidataservice.dk/dataset/Gasflow" -Method GET

    # Show the first 3 results
    $response.records | Select-Object -First 3 | Format-Table GasDay, KWhFromBiogas, KWhFromNorthSea, KWhToOrFromStorage

}
catch {
    Write-Host "Error making API call: $_" -ForegroundColor Red
}
#endregion

#region Authentication Methods
#region 1. Basic Authentication
Write-Host "1. Basic Authentication Example:" -ForegroundColor Yellow
$username = "your_username"
$password = "your_password"
$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("${username}:${password}")))

$basicAuthExample = @{
    Uri     = "https://api.example.com/endpoint"
    Method  = "GET"
    Headers = @{
        Authorization = "Basic $base64AuthInfo"
    }
}
Write-Host "Basic Auth Header: Authorization: Basic $base64AuthInfo"

#endregion

#region 2. API Key Authentication
Write-Host "2. API Key Authentication Example:" -ForegroundColor Yellow
$apiKey = "your_api_key"

# API key in header
$apiKeyHeaderExample = @{
    Uri     = "https://api.example.com/endpoint"
    Method  = "GET"
    Headers = @{
        "X-API-Key" = $apiKey
    }
}
Write-Host "API Key Header: X-API-Key: $apiKey"

# API key in query parameter
$apiKeyQueryExample = @{
    Uri    = "https://api.example.com/endpoint?api_key=$apiKey"
    Method = "GET"
}
Write-Host "API Key Query: ?api_key=$apiKey"

#endregion

#region 3. OAuth 2.0 (Bearer Token)
Write-Host "3. OAuth Bearer Token Example:" -ForegroundColor Yellow
# Normally you would obtain this token via an OAuth flow like client credentials or authorization code using secrets or certificates
# An example can be seen here in regards to authenticating to MSGraph: https://mynster9361.github.io/posts/ClientSecretAuthentication/#now-lets-take-what-we-just-created-and-ask-for-a-token
$bearerToken = "your_oauth_token"

$oauthExample = @{
    Uri     = "https://api.example.com/endpoint"
    Method  = "GET"
    Headers = @{
        Authorization = "Bearer $bearerToken"
    }
}
Write-Host "OAuth Header: Authorization: Bearer $bearerToken"
#endregion
#endregion



#region GET example with next pages
# https://disneyapi.dev/docs/

$uri = "https://api.disneyapi.dev/character"
[System.Collections.ArrayList]$data = @()
try {
    do {
        $response = Invoke-RestMethod -Uri $uri -Method GET
        Write-Host "Retrieved page with $($response.data.Count) characters." -ForegroundColor Green

        # Display character names from the current page
        $response.data | ForEach-Object { Write-Host "Character: $($_.name)" -ForegroundColor Yellow }
        $data.AddRange($response.data)
        # Get the next page URL
        $uri = $response.info.nextPage
    } while ($uri)
}
catch {
    Write-Host "Error making paginated GET request: $_" -ForegroundColor Red
}
#endregion

#region working with limits
try {
    $response = Invoke-RestMethod -Uri "https://api.energidataservice.dk/dataset/Gasflow?limit=100" -Method GET

    $response.records | Select-Object -First 3 | Format-Table GasDay, KWhFromBiogas, KWhFromNorthSea, KWhToOrFromStorage
    $response.records.Count
    Write-Host "Total records retrieved: $($response.records.Count)" -ForegroundColor Green
}
catch {
    Write-Host "Error making API call: $_" -ForegroundColor Red
}
#endregion

#region working with offsets
$i = 0
[System.UriBuilder]$uriBuilder = New-Object System.UriBuilder "https://api.energidataservice.dk/dataset/Gasflow"
do {
    $uriBuilder.Query = "sort=GasDay DESC&offset=$i"
    $response = Invoke-RestMethod -Uri $uriBuilder.Uri -Method GET
    Write-Host "Retrieved $(($response.records).Count) records starting from offset $i" -ForegroundColor Green
    $i += $response.limit
} while ($i -lt $response.total)
#endregion
