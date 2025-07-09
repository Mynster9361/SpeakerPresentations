<#
.SYNOPSIS
    Creates sample data in Azure AD for Microsoft Graph API demonstrations

.DESCRIPTION
    This script creates various sample resources in your Azure AD tenant to provide
    meaningful data for Microsoft Graph API queries and demonstrations. It creates:
    - Sample users with different job titles and departments
    - Security and mail-enabled groups
    - Sample applications with different configurations
    - Group memberships

.NOTES
    Requires:
    - PowerShell 5.1 or later
    - Valid Azure AD application registration with appropriate permissions
    - Environment variables: tenantId, clientId, clientSecret
    - Application permissions: User.ReadWrite.All, Group.ReadWrite.All, Application.ReadWrite.All, AppRoleAssignment.ReadWrite.All, User.Invite.All

.PARAMETER DemoMode
    Run in demo mode with detailed output and confirmation prompts

.PARAMETER SkipUsers
    Skip creating sample users

.PARAMETER SkipGroups
    Skip creating sample groups

.PARAMETER SkipApplications
    Skip creating sample applications

.PARAMETER CleanupOnly
    Only cleanup existing sample data using the created-demo-resources.json file

.PARAMETER WhatIf
    Show what would be cleaned up without actually deleting resources

.EXAMPLE
    .\Create-SampleData.ps1 -DemoMode
    Creates sample data with detailed output and confirmation prompts

.EXAMPLE
    .\Create-SampleData.ps1 -SkipUsers
    Creates sample data but skips creating users

.EXAMPLE
    .\Create-SampleData.ps1 -SkipAppRoleAssignments
    Creates sample data but skips creating app role assignments

.EXAMPLE
    .\Create-SampleData.ps1 -SkipGuestUsers
    Creates sample data but skips creating guest users

.EXAMPLE
    .\Create-SampleData.ps1 -WhatIf
    Shows what demo resources would be cleaned up without deleting them

.EXAMPLE
    .\Create-SampleData.ps1 -CleanupOnly
    Removes all demo resources tracked in created-demo-resources.json

.EXAMPLE
    .\Create-SampleData.ps1 -UseBatch
    Creates sample data using batch requests for faster execution
#>

[CmdletBinding()]
param(
  [Parameter(HelpMessage = "Run in demo mode with detailed output")]
  [switch]$DemoMode,

  [Parameter(HelpMessage = "Skip creating sample users")]
  [switch]$SkipUsers,

  [Parameter(HelpMessage = "Skip creating sample groups")]
  [switch]$SkipGroups,

  [Parameter(HelpMessage = "Skip creating sample applications")]
  [switch]$SkipApplications,

  [Parameter(HelpMessage = "Skip creating app role assignments")]
  [switch]$SkipAppRoleAssignments,

  [Parameter(HelpMessage = "Skip creating guest users")]
  [switch]$SkipGuestUsers,

  [Parameter(HelpMessage = "Only cleanup existing sample data")]
  [switch]$CleanupOnly,

  [Parameter(HelpMessage = "Show what would be cleaned up without actually deleting")]
  [switch]$WhatIf,

  [Parameter(HelpMessage = "Use batch requests for faster resource creation")]
  [switch]$UseBatch
)

# Import the helper functions
. ./helper_function_msgraph.ps1

# Batch processing helper function
function Invoke-GraphBatchRequest {
  param(
    [array]$Requests,
    [hashtable]$Headers,
    [int]$BatchSize = 20
  )

  $allResults = @()
  $batches = [math]::Ceiling($Requests.Count / $BatchSize)

  for ($batch = 0; $batch -lt $batches; $batch++) {
    $start = $batch * $BatchSize
    $end = [math]::Min($start + $BatchSize - 1, $Requests.Count - 1)
    $batchRequests = $Requests[$start..$end]

    # Create batch body with proper JSON serialization
    $batchBody = @{
      requests = $batchRequests
    }

    # Convert to JSON with explicit array handling for nested objects
    $jsonBody = $batchBody | ConvertTo-Json -Depth 20 -Compress

    try {
      $response = Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/`$batch" -Headers $Headers -Method POST -Body $jsonBody -ContentType "application/json"
      $allResults += $response.responses

      # Add small delay between batches to avoid throttling
      if ($batch -lt ($batches - 1)) {
        Start-Sleep -Milliseconds 100
      }
    }
    catch {
      Write-Warning "Batch request failed: $($_.Exception.Message)"
    }
  }

  return $allResults
}

# Configuration
$tenantId = $env:tenantId
$clientId = $env:clientId
$clientSecret = $env:clientSecret

if (-not $tenantId -or -not $clientId -or -not $clientSecret) {
  Write-Error "Please set the required environment variables: tenantId, clientId, clientSecret"
  exit 1
}

# Authentication
Write-Host "🔐 Authenticating with Microsoft Graph..." -ForegroundColor Blue
try {
  $auth = Get-GraphApiToken -TenantId $tenantId -ClientId $clientId -ClientSecret $clientSecret
  $authHeaders = $auth.Headers
  Write-Host "✅ Authentication successful!" -ForegroundColor Green
}
catch {
  Write-Error "Authentication failed: $($_.Exception.Message)"
  exit 1
}

$graphApiUri = "https://graph.microsoft.com/v1.0"

# Sample data definitions - Generate realistic sample data
$timestamp = (Get-Date).Ticks
$randomSuffix = -join ((65..90) + (97..122) | Get-Random -Count 4 | ForEach-Object { [char]$_ })
$uniqueSuffix = "$timestamp$randomSuffix"

# Define arrays for generating realistic names and roles
$firstNames = @("John", "Jane", "Michael", "Sarah", "David", "Emily", "Robert", "Lisa", "James", "Maria", "William", "Linda", "Richard", "Patricia", "Charles", "Jennifer", "Thomas", "Elizabeth", "Christopher", "Susan", "Daniel", "Jessica", "Matthew", "Margaret", "Anthony", "Karen", "Mark", "Nancy", "Donald", "Betty", "Steven", "Helen", "Paul", "Sandra", "Andrew", "Donna", "Joshua", "Carol", "Kenneth", "Ruth", "Kevin", "Sharon", "Brian", "Michelle", "George", "Laura", "Edward", "Sarah", "Ronald", "Kimberly", "Timothy", "Deborah", "Jason", "Dorothy", "Jeffrey", "Amy", "Ryan", "Angela", "Jacob", "Ashley")

$lastNames = @("Smith", "Johnson", "Williams", "Brown", "Jones", "Garcia", "Miller", "Davis", "Rodriguez", "Martinez", "Hernandez", "Lopez", "Gonzalez", "Wilson", "Anderson", "Thomas", "Taylor", "Moore", "Jackson", "Martin", "Lee", "Perez", "Thompson", "White", "Harris", "Sanchez", "Clark", "Ramirez", "Lewis", "Robinson", "Walker", "Young", "Allen", "King", "Wright", "Scott", "Torres", "Nguyen", "Hill", "Flores", "Green", "AdAMS", "Nelson", "Baker", "Hall", "Rivera", "Campbell", "Mitchell", "Carter", "Roberts")

$departments = @("Engineering", "Sales", "Marketing", "Human Resources", "Finance", "Operations", "IT Support", "Customer Service", "Product Management", "Quality Assurance", "Research", "Legal", "Business Development", "Data Analytics", "Security", "Facilities", "Training", "Procurement")

$jobTitles = @{
  "Engineering"          = @("Software Developer", "Senior Developer", "Engineering Manager", "Tech Lead", "DevOps Engineer", "QA Engineer", "Systems Architect", "Frontend Developer", "Backend Developer", "Full Stack Developer")
  "Sales"                = @("Sales Representative", "Sales Manager", "Account Executive", "Sales Director", "Business Development Manager", "Inside Sales Rep", "Regional Sales Manager", "Sales Coordinator")
  "Marketing"            = @("Marketing Specialist", "Marketing Manager", "Digital Marketing Manager", "Content Marketing Manager", "SEO Specialist", "Social Media Manager", "Brand Manager", "Marketing Director")
  "Human Resources"      = @("HR Specialist", "HR Manager", "Recruiter", "HR Director", "Training Coordinator", "Benefits Administrator", "HR Business Partner")
  "Finance"              = @("Financial Analyst", "Accountant", "Finance Manager", "Controller", "CFO", "Budget Analyst", "Accounts Payable Specialist", "Financial Advisor")
  "Operations"           = @("Operations Manager", "Operations Specialist", "Process Improvement Manager", "Supply Chain Manager", "Logistics Coordinator", "Operations Director")
  "IT Support"           = @("IT Support Specialist", "System Administrator", "Network Administrator", "IT Manager", "Help Desk Technician", "Infrastructure Engineer")
  "Customer Service"     = @("Customer Service Representative", "Customer Success Manager", "Support Specialist", "Customer Service Manager", "Technical Support Specialist")
  "Product Management"   = @("Product Manager", "Senior Product Manager", "Product Owner", "Product Director", "Product Marketing Manager", "Product Analyst")
  "Quality Assurance"    = @("QA Analyst", "QA Manager", "Test Engineer", "Quality Control Specialist", "QA Director", "Automation Test Engineer")
  "Research"             = @("Research Analyst", "Research Manager", "Data Scientist", "Research Director", "Market Research Analyst", "UX Researcher")
  "Legal"                = @("Legal Counsel", "Paralegal", "Compliance Manager", "Legal Assistant", "General Counsel", "Contract Manager")
  "Business Development" = @("Business Development Manager", "Partnership Manager", "BD Representative", "Strategic Partnerships Director", "Business Analyst")
  "Data Analytics"       = @("Data Analyst", "Business Intelligence Analyst", "Data Engineer", "Analytics Manager", "Data Scientist", "Reporting Specialist")
  "Security"             = @("Security Analyst", "Information Security Manager", "Cybersecurity Specialist", "Security Engineer", "CISO", "Compliance Officer")
  "Facilities"           = @("Facilities Manager", "Facilities Coordinator", "Building Maintenance", "Office Manager", "Facilities Director")
  "Training"             = @("Training Specialist", "Learning & Development Manager", "Training Coordinator", "Instructional Designer", "Training Director")
  "Procurement"          = @("Procurement Specialist", "Purchasing Manager", "Vendor Manager", "Contract Specialist", "Procurement Director", "Supply Chain Analyst")
}

$locations = @("US", "CA", "GB", "DE", "FR", "AU", "IN", "JP", "BR", "MX")

# Generate 75+ users (increased for better demo data)
$sampleUsers = @()
for ($i = 1; $i -le 75; $i++) {
  $firstName = $firstNames | Get-Random
  $lastName = $lastNames | Get-Random
  $department = $departments | Get-Random
  $jobTitle = $jobTitles[$department] | Get-Random
  $location = $locations | Get-Random

  $userPrincipalName = "$($firstName.ToLower()).$($lastName.ToLower()).$i@44fy5j.onmicrosoft.com"
  $mailNickname = "$($firstName.ToLower()).$($lastName.ToLower()).$i"

  $sampleUsers += @{
    displayName       = "$firstName $lastName"
    givenName         = $firstName
    surname           = $lastName
    userPrincipalName = $userPrincipalName
    mailNickname      = $mailNickname
    jobTitle          = $jobTitle
    department        = $department
    companyName       = "Demo Company"
    usageLocation     = $location
  }
}

# Generate 50+ groups with various types
$groupTypes = @(
  @{ type = "Security"; mailEnabled = $false; securityEnabled = $true; groupTypes = @() },
  @{ type = "Mail"; mailEnabled = $true; securityEnabled = $false; groupTypes = @("Unified") },
  @{ type = "Office365"; mailEnabled = $true; securityEnabled = $true; groupTypes = @("Unified") }
)

$groupPrefixes = @("Team", "Department", "Project", "Committee", "Working Group", "Task Force", "Division", "Unit", "Board", "Council")
$groupPurposes = @("Collaboration", "Communication", "Development", "Support", "Management", "Analysis", "Planning", "Coordination", "Innovation", "Quality")

$sampleGroups = @()
$groupCounter = 1

# Add department-based groups
foreach ($dept in $departments) {
  $groupType = $groupTypes | Get-Random
  $sampleGroups += @{
    displayName     = "$dept Team"
    description     = "All $dept team members"
    groupTypes      = $groupType.groupTypes
    mailEnabled     = $groupType.mailEnabled
    securityEnabled = $groupType.securityEnabled
    mailNickname    = "$($dept.ToLower().Replace(' ', '-'))-team-$groupCounter-$uniqueSuffix"
  }
  $groupCounter++
}

# Add project and functional groups (increased for better demo data)
$projectNames = @("Alpha", "Beta", "Gamma", "Delta", "Phoenix", "Orion", "Titan", "Nova", "Quantum", "Fusion", "Matrix", "Nexus", "Catalyst", "Velocity", "Summit", "Horizon", "Pinnacle", "Zenith", "Apex", "Prime", "Eclipse", "Thunder", "Lightning", "Storm", "Cyclone", "Meteor", "Comet", "Nebula", "Galaxy", "Universe")

for ($i = 1; $i -le 45; $i++) {
  $prefix = $groupPrefixes | Get-Random
  $purpose = $groupPurposes | Get-Random
  $projectName = $projectNames | Get-Random
  $groupType = $groupTypes | Get-Random

  $displayName = if ($i -le 30) { "Project $projectName $prefix" } else { "$purpose $prefix $i" }
  $mailNickname = $displayName.ToLower().Replace(' ', '-').Replace('&', 'and') + "-$groupCounter-$uniqueSuffix"

  $sampleGroups += @{
    displayName     = $displayName
    description     = "Group for $displayName activities and collaboration"
    groupTypes      = $groupType.groupTypes
    mailEnabled     = $groupType.mailEnabled
    securityEnabled = $groupType.securityEnabled
    mailNickname    = $mailNickname
  }
  $groupCounter++
}

# Add some special groups for demo purposes
$specialGroups = @(
  @{ name = "Talk Participants"; desc = "People participating in talks and presentations" },
  @{ name = "Demo Users"; desc = "Users created for demonstration purposes" },
  @{ name = "PowerShell Enthusiasts"; desc = "Group for PowerShell and automation enthusiasts" },
  @{ name = "Graph API Developers"; desc = "Developers working with Microsoft Graph API" },
  @{ name = "Azure Administrators"; desc = "Azure and cloud administrators" }
)

foreach ($group in $specialGroups) {
  $groupType = $groupTypes | Get-Random
  $sampleGroups += @{
    displayName     = $group.name
    description     = $group.desc
    groupTypes      = $groupType.groupTypes
    mailEnabled     = $groupType.mailEnabled
    securityEnabled = $groupType.securityEnabled
    mailNickname    = "$($group.name.ToLower().Replace(' ', '-'))-$groupCounter-$uniqueSuffix"
  }
  $groupCounter++
}

# Generate 10+ applications
$appTypes = @("Web", "Mobile", "API", "Desktop", "Service", "Integration", "Analytics", "Monitoring", "Security", "Productivity")
$appPurposes = @("Customer Portal", "Admin Dashboard", "Mobile App", "API Gateway", "Data Service", "Monitoring Tool", "Analytics Platform", "Security Scanner", "Productivity Suite", "Communication Hub")
$frameworks = @("React", "Angular", "Vue", "ASP.NET", "Node.js", "Python Flask", "Django", "Spring Boot", "Express", "Blazor")

$sampleApplications = @()

for ($i = 1; $i -le 20; $i++) {
  $appType = $appTypes | Get-Random
  $purpose = $appPurposes | Get-Random
  $framework = $frameworks | Get-Random

  $displayName = if ($i -le 15) { "$appType $purpose" } else { "Demo $framework $appType $i" }

  # Generate different redirect URI patterns
  $redirectUris = switch ($appType) {
    "Web" { @("http://localhost:$((3000 + $i))", "http://localhost:$((3000 + $i))/callback", "https://demo-app-$i.azurewebsites.net") }
    "Mobile" { @("http://localhost:$((8000 + $i))", "ms-app://demo-mobile-$i") }
    "API" { @("https://api-demo-$i.example.com/auth/callback") }
    "Desktop" { @("http://localhost:$((5000 + $i))", "urn:ietf:wg:oauth:2.0:oob") }
    default { @("http://localhost:$((4000 + $i))") }
  }

  $isPublicClient = $appType -in @("Mobile", "Desktop")

  # Create application object with proper array handling
  $appObject = @{
    displayName = $displayName
    tags        = @("Demo", $appType, $framework)
  }

  # Add web configuration for non-public clients
  if (-not $isPublicClient) {
    $appObject.web = @{
      redirectUris          = $redirectUris
      implicitGrantSettings = @{
        enableIdTokenIssuance     = $true
        enableAccessTokenIssuance = ($appType -eq "Web")
      }
    }
  }

  # Add public client configuration for public clients
  if ($isPublicClient) {
    $appObject.publicClient = @{
      redirectUris = $redirectUris
    }
  }

  $sampleApplications += $appObject
}

Write-Host "📊 Generated sample data:" -ForegroundColor Cyan
Write-Host "  👥 Users: $($sampleUsers.Count)" -ForegroundColor Green
Write-Host "  📁 Groups: $($sampleGroups.Count)" -ForegroundColor Green
Write-Host "  🔧 Applications: $($sampleApplications.Count)" -ForegroundColor Green

# Generate guest users (external users from partner organizations)
$guestDomains = @("partner1.com", "partner2.com", "contractor.org", "vendor.net", "consultant.co", "external.biz", "freelancer.info", "agency.pro")
$guestCompanies = @("Partner Corp", "Contractor Inc", "Vendor Solutions", "Consultant Group", "External Services", "Freelancer Hub", "Agency Pro", "Collaboration Partners")

$sampleGuestUsers = @()
for ($i = 1; $i -le 15; $i++) {
  $firstName = $firstNames | Get-Random
  $lastName = $lastNames | Get-Random
  $domain = $guestDomains | Get-Random
  $company = $guestCompanies | Get-Random

  $invitedUserEmailAddress = "$($firstName.ToLower()).$($lastName.ToLower())@$domain"

  $sampleGuestUsers += @{
    invitedUserEmailAddress = $invitedUserEmailAddress
    invitedUserDisplayName  = "$firstName $lastName"
    inviteRedirectUrl       = "https://myapp.contoso.com"
    invitedUserType         = "Guest"
    sendInvitationMessage   = $false
    invitedUserMessageInfo  = @{
      messageLanguage       = "en-US"
      customizedMessageBody = "Welcome to our organization! Please accept this invitation to collaborate with us."
    }
    companyName             = $company
    jobTitle                = @("External Consultant", "Partner Representative", "Contractor", "Vendor Specialist", "External Developer", "Guest Researcher", "Partner Manager", "External Advisor") | Get-Random
    department              = @("External", "Partners", "Contractors", "Vendors", "Consultants") | Get-Random
  }
}

Write-Host "  👤 Guest Users: $($sampleGuestUsers.Count)" -ForegroundColor Green

# Configuration for tracking created resources
$createdResourcesFile = "./created-demo-resources.json"

# Cleanup function - now uses JSON file for precise cleanup
function Remove-SampleData {
  param([switch]$WhatIf)

  Write-Host "🧹 $(if ($WhatIf) { 'Previewing cleanup of' } else { 'Cleaning up' }) existing sample data..." -ForegroundColor Yellow

  if (-not (Test-Path $createdResourcesFile)) {
    Write-Warning "No created resources file found at: $createdResourcesFile"
    Write-Host "ℹ️  This could mean no demo data was previously created or the file was moved/deleted." -ForegroundColor Blue
    return
  }

  try {
    $savedResources = Get-Content $createdResourcesFile -Raw | ConvertFrom-Json
    Write-Host "📋 Found created resources file with:" -ForegroundColor Cyan
    Write-Host "  👥 Users: $($savedResources.Users.Count)" -ForegroundColor Yellow
    Write-Host "  📁 Groups: $($savedResources.Groups.Count)" -ForegroundColor Yellow
    Write-Host "  🔧 Applications: $($savedResources.Applications.Count)" -ForegroundColor Yellow
    Write-Host "  🔐 App Role Assignments: $($savedResources.AppRoleAssignments.Count)" -ForegroundColor Yellow
    Write-Host "  👤 Guest Users: $($savedResources.GuestUsers.Count)" -ForegroundColor Yellow
  }
  catch {
    Write-Error "Failed to read created resources file: $($_.Exception.Message)"
    return
  }

  if ($WhatIf) {
    Write-Host "`n👀 Resources that would be removed:" -ForegroundColor Cyan

    if ($savedResources.Users) {
      Write-Host "`n👥 Users ($($savedResources.Users.Count)):" -ForegroundColor Yellow
      $savedResources.Users | ForEach-Object { Write-Host "  - $($_.displayName) ($($_.userPrincipalName))" -ForegroundColor Gray }
    }

    if ($savedResources.Groups) {
      Write-Host "`n📁 Groups ($($savedResources.Groups.Count)):" -ForegroundColor Yellow
      $savedResources.Groups | ForEach-Object { Write-Host "  - $($_.displayName)" -ForegroundColor Gray }
    }

    if ($savedResources.Applications) {
      Write-Host "`n🔧 Applications ($($savedResources.Applications.Count)):" -ForegroundColor Yellow
      $savedResources.Applications | ForEach-Object { Write-Host "  - $($_.displayName)" -ForegroundColor Gray }
    }

    if ($savedResources.AppRoleAssignments) {
      Write-Host "`n🔐 App Role Assignments ($($savedResources.AppRoleAssignments.Count)):" -ForegroundColor Yellow
      $savedResources.AppRoleAssignments | ForEach-Object { Write-Host "  - $($_.userDisplayName) -> $($_.resourceDisplayName)" -ForegroundColor Gray }
    }

    if ($savedResources.GuestUsers) {
      Write-Host "`n👤 Guest Users ($($savedResources.GuestUsers.Count)):" -ForegroundColor Yellow
      $savedResources.GuestUsers | ForEach-Object { Write-Host "  - $($_.displayName) ($($_.userPrincipalName))" -ForegroundColor Gray }
    }

    Write-Host "`nℹ️  To actually remove these resources, run: .\Create-SampleData.ps1 -CleanupOnly" -ForegroundColor Blue
    return
  }

  $successCount = @{ Users = 0; Groups = 0; Applications = 0; AppRoleAssignments = 0; GuestUsers = 0 }
  $errorCount = @{ Users = 0; Groups = 0; Applications = 0; AppRoleAssignments = 0; GuestUsers = 0 }

  # Remove guest users first (they might have app role assignments)
  if ($savedResources.GuestUsers) {
    Write-Host "`n🗑️  Removing guest users..." -ForegroundColor Cyan
    foreach ($guestUser in $savedResources.GuestUsers) {
      try {
        Write-Host "  Removing guest user: $($guestUser.displayName) (ID: $($guestUser.id))" -ForegroundColor Gray
        Invoke-GraphApiRequest -Uri "$graphApiUri/users/$($guestUser.id)" -Headers $authHeaders -Method DELETE
        $successCount.GuestUsers++
      }
      catch {
        Write-Warning "Failed to remove guest user $($guestUser.displayName): $($_.Exception.Message)"
        $errorCount.GuestUsers++
      }
    }
  }

  # Remove app role assignments first (dependencies)
  if ($savedResources.AppRoleAssignments) {
    Write-Host "`n🗑️  Removing app role assignments..." -ForegroundColor Cyan
    foreach ($assignment in $savedResources.AppRoleAssignments) {
      try {
        Write-Host "  Removing assignment: $($assignment.userDisplayName) -> $($assignment.resourceDisplayName)" -ForegroundColor Gray
        Invoke-GraphApiRequest -Uri "$graphApiUri/users/$($assignment.principalId)/appRoleAssignments/$($assignment.id)" -Headers $authHeaders -Method DELETE
        $successCount.AppRoleAssignments++
      }
      catch {
        Write-Warning "Failed to remove app role assignment for $($assignment.userDisplayName): $($_.Exception.Message)"
        $errorCount.AppRoleAssignments++
      }
    }
  }

  # Remove users
  if ($savedResources.Users) {
    Write-Host "`n🗑️  Removing users..." -ForegroundColor Cyan
    foreach ($user in $savedResources.Users) {
      try {
        Write-Host "  Removing user: $($user.displayName) (ID: $($user.id))" -ForegroundColor Gray
        Invoke-GraphApiRequest -Uri "$graphApiUri/users/$($user.id)" -Headers $authHeaders -Method DELETE
        $successCount.Users++
      }
      catch {
        Write-Warning "Failed to remove user $($user.displayName): $($_.Exception.Message)"
        $errorCount.Users++
      }
    }
  }

  # Remove groups
  if ($savedResources.Groups) {
    Write-Host "`n🗑️  Removing groups..." -ForegroundColor Cyan
    foreach ($group in $savedResources.Groups) {
      try {
        Write-Host "  Removing group: $($group.displayName) (ID: $($group.id))" -ForegroundColor Gray
        Invoke-GraphApiRequest -Uri "$graphApiUri/groups/$($group.id)" -Headers $authHeaders -Method DELETE
        $successCount.Groups++
      }
      catch {
        Write-Warning "Failed to remove group $($group.displayName): $($_.Exception.Message)"
        $errorCount.Groups++
      }
    }
  }

  # Remove applications
  if ($savedResources.Applications) {
    Write-Host "`n🗑️  Removing applications..." -ForegroundColor Cyan
    foreach ($app in $savedResources.Applications) {
      try {
        Write-Host "  Removing application: $($app.displayName) (ID: $($app.id))" -ForegroundColor Gray
        Invoke-GraphApiRequest -Uri "$graphApiUri/applications/$($app.id)" -Headers $authHeaders -Method DELETE
        $successCount.Applications++
      }
      catch {
        Write-Warning "Failed to remove application $($app.displayName): $($_.Exception.Message)"
        $errorCount.Applications++
      }
    }
  }

  # Remove the tracking file if cleanup was successful
  $totalErrors = $errorCount.Users + $errorCount.Groups + $errorCount.Applications + $errorCount.AppRoleAssignments + $errorCount.GuestUsers
  if ($totalErrors -eq 0) {
    Remove-Item $createdResourcesFile -Force
    Write-Host "`n✅ Cleanup completed successfully! Removed tracking file." -ForegroundColor Green
  }
  else {
    Write-Host "`n⚠️  Cleanup completed with $totalErrors errors. Keeping tracking file for retry." -ForegroundColor Yellow
  }

  Write-Host "`n📊 Cleanup Summary:" -ForegroundColor Cyan
  Write-Host "  👥 Users: $($successCount.Users) removed, $($errorCount.Users) errors" -ForegroundColor $(if ($errorCount.Users -eq 0) { "Green" } else { "Yellow" })
  Write-Host "  📁 Groups: $($successCount.Groups) removed, $($errorCount.Groups) errors" -ForegroundColor $(if ($errorCount.Groups -eq 0) { "Green" } else { "Yellow" })
  Write-Host "  🔧 Applications: $($successCount.Applications) removed, $($errorCount.Applications) errors" -ForegroundColor $(if ($errorCount.Applications -eq 0) { "Green" } else { "Yellow" })
  Write-Host "  🔐 App Role Assignments: $($successCount.AppRoleAssignments) removed, $($errorCount.AppRoleAssignments) errors" -ForegroundColor $(if ($errorCount.AppRoleAssignments -eq 0) { "Green" } else { "Yellow" })
  Write-Host "  👤 Guest Users: $($successCount.GuestUsers) removed, $($errorCount.GuestUsers) errors" -ForegroundColor $(if ($errorCount.GuestUsers -eq 0) { "Green" } else { "Yellow" })
}

# Function to save created resources to JSON file
function Save-CreatedResources {
  param([hashtable]$Resources)

  try {
    $jsonData = $Resources | ConvertTo-Json -Depth 10
    $jsonData | Out-File -FilePath $createdResourcesFile -Encoding UTF8
    Write-Host "💾 Saved created resources to: $createdResourcesFile" -ForegroundColor Blue
  }
  catch {
    Write-Warning "Failed to save created resources: $($_.Exception.Message)"
  }
}

# Main execution
Write-Host "🚀 Starting Azure AD Sample Data Creation" -ForegroundColor Magenta
Write-Host $("=" * 50) -ForegroundColor Magenta

if ($CleanupOnly -or $WhatIf) {
  Remove-SampleData -WhatIf:$WhatIf
  exit 0
}

# Cleanup existing data first
if ($DemoMode) {
  $cleanup = Read-Host "Do you want to cleanup existing sample data first? (y/N)"
  if ($cleanup -eq 'y' -or $cleanup -eq 'Y') {
    Remove-SampleData -WhatIf:$false
  }
}

$createdResources = @{
  Users              = @()
  Groups             = @()
  Applications       = @()
  AppRoleAssignments = @()
  GuestUsers         = @()
}

# Create Users
if (-not $SkipUsers) {
  Write-Host "`n👥 Creating Sample Users..." -ForegroundColor Cyan

  if ($UseBatch) {
    # Create batch requests for users
    $userRequests = @()
    for ($i = 0; $i -lt $sampleUsers.Count; $i++) {
      $user = $sampleUsers[$i]

      $userBody = @{
        displayName       = $user.displayName
        givenName         = $user.givenName
        surname           = $user.surname
        userPrincipalName = $user.userPrincipalName
        mailNickname      = $user.mailNickname
        jobTitle          = $user.jobTitle
        department        = $user.department
        companyName       = "Demo Company"
        usageLocation     = $user.usageLocation
        accountEnabled    = $true
        passwordProfile   = @{
          password                      = "TempPassword123!"
          forceChangePasswordNextSignIn = $true
        }
      }

      $userRequests += @{
        id      = "user-$i"
        method  = "POST"
        url     = "/users"
        body    = $userBody
        headers = @{ "Content-Type" = "application/json" }
      }
    }

    $responses = Invoke-GraphBatchRequest -Requests $userRequests -Headers $authHeaders

    foreach ($response in $responses) {
      if ($response.status -eq 201) {
        $createdResources.Users += $response.body
        Write-Host "    ✅ Created: $($response.body.displayName)" -ForegroundColor Green
      }
      else {
        $userIndex = [int]($response.id -replace "user-", "")
        $userName = if ($userIndex -lt $sampleUsers.Count) { $sampleUsers[$userIndex].displayName } else { "Unknown User" }
        Write-Warning "Failed to create user $userName (Status: $($response.status)): $($response.body.error.message)"
      }
    }
  }
  else {
    # Sequential user creation
    foreach ($user in $sampleUsers) {
      try {
        if ($DemoMode) {
          Write-Host "  Creating user: $($user.displayName) ($($user.jobTitle))" -ForegroundColor Yellow
        }

        $userBody = @{
          displayName       = $user.displayName
          givenName         = $user.givenName
          surname           = $user.surname
          userPrincipalName = $user.userPrincipalName
          mailNickname      = $user.mailNickname
          jobTitle          = $user.jobTitle
          department        = $user.department
          companyName       = $user.companyName
          usageLocation     = $user.usageLocation
          accountEnabled    = $true
          passwordProfile   = @{
            password                      = "TempPassword123!"
            forceChangePasswordNextSignIn = $true
          }
        }

        $createdUser = Invoke-GraphApiRequest -Uri "$graphApiUri/users" -Headers $authHeaders -Method POST -Body $userBody
        $createdResources.Users += $createdUser

        Write-Host "    ✅ Created: $($createdUser.displayName)" -ForegroundColor Green
      }
      catch {
        Write-Warning "Failed to create user $($user.displayName): $($_.Exception.Message)"
      }
    }
  }
}

# Create Groups
if (-not $SkipGroups) {
  Write-Host "`n📁 Creating Sample Groups..." -ForegroundColor Cyan

  if ($UseBatch) {
    # Create batch requests for groups
    $groupRequests = @()
    for ($i = 0; $i -lt $sampleGroups.Count; $i++) {
      $group = $sampleGroups[$i]

      $groupBody = @{
        displayName     = $group.displayName
        description     = $group.description
        groupTypes      = $group.groupTypes
        mailEnabled     = $group.mailEnabled
        securityEnabled = $group.securityEnabled
        mailNickname    = $group.mailNickname
      }

      $groupRequests += @{
        id      = "group-$i"
        method  = "POST"
        url     = "/groups"
        body    = $groupBody
        headers = @{ "Content-Type" = "application/json" }
      }
    }

    $responses = Invoke-GraphBatchRequest -Requests $groupRequests -Headers $authHeaders

    foreach ($response in $responses) {
      if ($response.status -eq 201) {
        $createdResources.Groups += $response.body
        Write-Host "    ✅ Created: $($response.body.displayName)" -ForegroundColor Green
      }
      else {
        $groupIndex = [int]($response.id -replace "group-", "")
        $groupName = if ($groupIndex -lt $sampleGroups.Count) { $sampleGroups[$groupIndex].displayName } else { "Unknown Group" }
        Write-Warning "Failed to create group $groupName (Status: $($response.status)): $($response.body.error.message)"
      }
    }
  }
  else {
    # Sequential group creation
    foreach ($group in $sampleGroups) {
      try {
        if ($DemoMode) {
          Write-Host "  Creating group: $($group.displayName)" -ForegroundColor Yellow
        }

        $groupBody = @{
          displayName     = $group.displayName
          description     = $group.description
          groupTypes      = $group.groupTypes
          mailEnabled     = $group.mailEnabled
          securityEnabled = $group.securityEnabled
          mailNickname    = $group.mailNickname
        }

        $createdGroup = Invoke-GraphApiRequest -Uri "$graphApiUri/groups" -Headers $authHeaders -Method POST -Body $groupBody
        $createdResources.Groups += $createdGroup

        Write-Host "    ✅ Created: $($createdGroup.displayName)" -ForegroundColor Green
      }
      catch {
        Write-Warning "Failed to create group $($group.displayName): $($_.Exception.Message)"
      }
    }
  }
}

# Create Applications
if (-not $SkipApplications) {
  Write-Host "`n🔧 Creating Sample Applications..." -ForegroundColor Cyan

  if ($UseBatch) {
    # Create batch requests for applications
    $appRequests = @()
    for ($i = 0; $i -lt $sampleApplications.Count; $i++) {
      $app = $sampleApplications[$i]

      # Build application body based on type with explicit array formatting
      $appBody = [ordered]@{
        displayName = $app.displayName
        tags        = [array]$app.tags
      }

      # Add web configuration if present
      if ($app.web) {
        $webConfig = [ordered]@{
          redirectUris          = [array]$app.web.redirectUris
          implicitGrantSettings = $app.web.implicitGrantSettings
        }
        $appBody.web = $webConfig
      }

      # Add public client configuration if present
      if ($app.publicClient) {
        $publicClientConfig = [ordered]@{
          redirectUris = [array]$app.publicClient.redirectUris
        }
        $appBody.publicClient = $publicClientConfig
      }

      $appRequests += @{
        id      = "app-$i"
        method  = "POST"
        url     = "/applications"
        body    = $appBody
        headers = @{ "Content-Type" = "application/json" }
      }
    }

    $responses = Invoke-GraphBatchRequest -Requests $appRequests -Headers $authHeaders

    foreach ($response in $responses) {
      if ($response.status -eq 201) {
        $createdResources.Applications += $response.body
        Write-Host "    ✅ Created: $($response.body.displayName)" -ForegroundColor Green
      }
      else {
        $appIndex = [int]($response.id -replace "app-", "")
        $appName = if ($appIndex -lt $sampleApplications.Count) { $sampleApplications[$appIndex].displayName } else { "Unknown App" }
        Write-Warning "Failed to create application $appName (Status: $($response.status)): $($response.body.error.message)"
      }
    }
  }
  else {
    # Sequential application creation
    foreach ($app in $sampleApplications) {
      try {
        if ($DemoMode) {
          Write-Host "  Creating application: $($app.displayName)" -ForegroundColor Yellow
        }

        # Build application body based on type
        $appBody = @{
          displayName = $app.displayName
          tags        = $app.tags
        }

        # Add web configuration if present
        if ($app.web) {
          $appBody.web = $app.web
        }

        # Add public client configuration if present
        if ($app.publicClient) {
          $appBody.publicClient = $app.publicClient
        }

        $createdApp = Invoke-GraphApiRequest -Uri "$graphApiUri/applications" -Headers $authHeaders -Method POST -Body $appBody
        $createdResources.Applications += $createdApp

        Write-Host "    ✅ Created: $($createdApp.displayName)" -ForegroundColor Green
      }
      catch {
        Write-Warning "Failed to create application $($app.displayName): $($_.Exception.Message)"
      }
    }
  }
}

# Create Group Memberships
if (-not $SkipUsers -and -not $SkipGroups -and $createdResources.Users.Count -gt 0 -and $createdResources.Groups.Count -gt 0) {
  Write-Host "Waiting 20 seconds for group and user creation to be in place" -ForegroundColor Cyan
  Start-Sleep -Seconds 20
  Write-Host "`n🔗 Creating Group Memberships..." -ForegroundColor Cyan

  # Add users to their department teams
  foreach ($dept in $departments) {
    $deptGroup = $createdResources.Groups | Where-Object { $_.displayName -eq "$dept Team" }
    $deptUsers = $createdResources.Users | Where-Object { $_.department -eq $dept }

    if ($deptGroup -and $deptUsers) {
      foreach ($user in $deptUsers) {
        try {
          $memberBody = @{
            "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($user.id)"
          }

          Invoke-GraphApiRequest -Uri "$graphApiUri/groups/$($deptGroup.id)/members/`$ref" -Headers $authHeaders -Method POST -Body $memberBody
          Write-Host "    ✅ Added $($user.displayName) to $($deptGroup.displayName)" -ForegroundColor Green
        }
        catch {
          Write-Warning "Failed to add $($user.displayName) to $($deptGroup.displayName): $($_.Exception.Message)"
        }
      }
    }
  }

  # Add some users to special groups
  $talkGroup = $createdResources.Groups | Where-Object { $_.displayName -eq "Talk Participants" }
  $demoGroup = $createdResources.Groups | Where-Object { $_.displayName -eq "Demo Users" }
  $psGroup = $createdResources.Groups | Where-Object { $_.displayName -eq "PowerShell Enthusiasts" }

  if ($talkGroup) {
    # Add first 10 users to Talk Participants
    $talkUsers = $createdResources.Users | Select-Object -First 10
    foreach ($user in $talkUsers) {
      try {
        $memberBody = @{ "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($user.id)" }
        Invoke-GraphApiRequest -Uri "$graphApiUri/groups/$($talkGroup.id)/members/`$ref" -Headers $authHeaders -Method POST -Body $memberBody
        Write-Host "    ✅ Added $($user.displayName) to Talk Participants" -ForegroundColor Green
      }
      catch {
        Write-Warning "Failed to add $($user.displayName) to Talk Participants: $($_.Exception.Message)"
      }
    }
  }

  if ($demoGroup) {
    # Add all users to Demo Users group
    foreach ($user in $createdResources.Users) {
      try {
        $memberBody = @{ "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($user.id)" }
        Invoke-GraphApiRequest -Uri "$graphApiUri/groups/$($demoGroup.id)/members/`$ref" -Headers $authHeaders -Method POST -Body $memberBody
        Write-Host "    ✅ Added $($user.displayName) to Demo Users" -ForegroundColor Green
      }
      catch {
        Write-Warning "Failed to add $($user.displayName) to Demo Users: $($_.Exception.Message)"
      }
    }
  }

  if ($psGroup) {
    # Add Engineering and IT Support users to PowerShell Enthusiasts
    $psUsers = $createdResources.Users | Where-Object { $_.department -in @("Engineering", "IT Support") }
    foreach ($user in $psUsers) {
      try {
        $memberBody = @{ "@odata.id" = "https://graph.microsoft.com/v1.0/users/$($user.id)" }
        Invoke-GraphApiRequest -Uri "$graphApiUri/groups/$($psGroup.id)/members/`$ref" -Headers $authHeaders -Method POST -Body $memberBody
        Write-Host "    ✅ Added $($user.displayName) to PowerShell Enthusiasts" -ForegroundColor Green
      }
      catch {
        Write-Warning "Failed to add $($user.displayName) to PowerShell Enthusiasts: $($_.Exception.Message)"
      }
    }
  }
}

# Create App Role Assignments
if (-not $SkipUsers -and -not $SkipApplications -and -not $SkipAppRoleAssignments -and $createdResources.Users.Count -gt 0 -and $createdResources.Applications.Count -gt 0) {
  Write-Host "`n🔐 Creating App Role Assignments..." -ForegroundColor Cyan

  # Wait for applications to be fully created
  Write-Host "Waiting 15 seconds for applications to be fully provisioned..." -ForegroundColor Yellow
  Start-Sleep -Seconds 15

  # First, we need to create service principals for the applications
  Write-Host "Creating service principals for applications..." -ForegroundColor Cyan
  $servicePrincipals = @()

  foreach ($app in $createdResources.Applications) {
    try {
      # Check if service principal already exists
      $existingSp = $null
      try {
        $existingSp = Invoke-GraphApiRequest -Uri "$graphApiUri/servicePrincipals?`$filter=appId eq '$($app.appId)'" -Headers $authHeaders -Method GET
      }
      catch {
        # Service principal doesn't exist, we'll create it
      }

      if ($existingSp -and $existingSp.value -and $existingSp.value.Count -gt 0) {
        $servicePrincipals += $existingSp.value[0]
        Write-Host "  ✅ Service principal already exists for: $($app.displayName)" -ForegroundColor Green
      }
      else {
        # Create service principal
        $spBody = @{
          appId       = $app.appId
          displayName = $app.displayName
          tags        = @("WindowsAzureActiveDirectoryIntegratedApp")
        }

        $sp = Invoke-GraphApiRequest -Uri "$graphApiUri/servicePrincipals" -Headers $authHeaders -Method POST -Body $spBody
        $servicePrincipals += $sp
        Write-Host "  ✅ Created service principal for: $($app.displayName)" -ForegroundColor Green
      }
    }
    catch {
      Write-Warning "Failed to create service principal for $($app.displayName): $($_.Exception.Message)"
    }
  }

  # Now create app role assignments
  # We'll assign users to applications based on their departments and job roles
  $assignmentPatterns = @(
    @{
      appPattern  = "Customer Portal"
      departments = @("Sales", "Marketing", "Customer Service")
      roleType    = "User"
    },
    @{
      appPattern  = "Admin Dashboard"
      departments = @("IT Support", "Security", "Operations")
      roleType    = "Admin"
    },
    @{
      appPattern  = "API Gateway"
      departments = @("Engineering", "IT Support")
      roleType    = "User"
    },
    @{
      appPattern  = "Mobile App"
      departments = @("Sales", "Marketing", "Customer Service", "Engineering")
      roleType    = "User"
    },
    @{
      appPattern  = "Monitoring Tool"
      departments = @("IT Support", "Operations", "Security")
      roleType    = "Admin"
    }
  )

  foreach ($pattern in $assignmentPatterns) {
    # Find matching applications
    $matchingApps = $createdResources.Applications | Where-Object { $_.displayName -like "*$($pattern.appPattern)*" }
    $matchingServicePrincipals = $servicePrincipals | Where-Object { $_.displayName -like "*$($pattern.appPattern)*" }

    if ($matchingApps -and $matchingServicePrincipals) {
      # Get users from matching departments
      $eligibleUsers = $createdResources.Users | Where-Object { $_.department -in $pattern.departments }

      foreach ($app in $matchingApps) {
        $sp = $matchingServicePrincipals | Where-Object { $_.appId -eq $app.appId }

        if ($sp -and $eligibleUsers) {
          # Assign a subset of eligible users (to avoid overwhelming the demo)
          $usersToAssign = $eligibleUsers | Get-Random -Count ([Math]::Min(5, $eligibleUsers.Count))

          foreach ($user in $usersToAssign) {
            try {
              # Create app role assignment
              $assignmentBody = @{
                principalId = $user.id
                resourceId  = $sp.id
                appRoleId   = "00000000-0000-0000-0000-000000000000"  # Default role
              }

              $assignment = Invoke-GraphApiRequest -Uri "$graphApiUri/users/$($user.id)/appRoleAssignments" -Headers $authHeaders -Method POST -Body $assignmentBody

              # Store assignment info for cleanup
              $assignmentInfo = @{
                id                  = $assignment.id
                principalId         = $user.id
                resourceId          = $sp.id
                appRoleId           = $assignment.appRoleId
                userDisplayName     = $user.displayName
                resourceDisplayName = $sp.displayName
                appId               = $app.appId
              }

              $createdResources.AppRoleAssignments += $assignmentInfo
              Write-Host "  ✅ Assigned $($user.displayName) to $($sp.displayName)" -ForegroundColor Green
            }
            catch {
              Write-Warning "Failed to assign $($user.displayName) to $($sp.displayName): $($_.Exception.Message)"
            }
          }
        }
      }
    }
  }

  # Create some additional random assignments for more demo data
  Write-Host "Creating additional random app role assignments..." -ForegroundColor Cyan

  # Get all service principals we created
  $availableServicePrincipals = $servicePrincipals | Where-Object { $_ -ne $null }
  $availableUsers = $createdResources.Users | Get-Random -Count 20  # Random subset of users

  foreach ($sp in $availableServicePrincipals) {
    # Assign 2-3 random users to each service principal
    $randomUsers = $availableUsers | Get-Random -Count (Get-Random -Minimum 2 -Maximum 4)

    foreach ($user in $randomUsers) {
      try {
        # Skip if already assigned
        $existingAssignment = $createdResources.AppRoleAssignments | Where-Object {
          $_.principalId -eq $user.id -and $_.resourceId -eq $sp.id
        }

        if (-not $existingAssignment) {
          $assignmentBody = @{
            principalId = $user.id
            resourceId  = $sp.id
            appRoleId   = "00000000-0000-0000-0000-000000000000"
          }

          $assignment = Invoke-GraphApiRequest -Uri "$graphApiUri/users/$($user.id)/appRoleAssignments" -Headers $authHeaders -Method POST -Body $assignmentBody

          $assignmentInfo = @{
            id                  = $assignment.id
            principalId         = $user.id
            resourceId          = $sp.id
            appRoleId           = $assignment.appRoleId
            userDisplayName     = $user.displayName
            resourceDisplayName = $sp.displayName
            appId               = $assignment.appId
          }

          $createdResources.AppRoleAssignments += $assignmentInfo
          Write-Host "  ✅ Random assignment: $($user.displayName) to $($sp.displayName)" -ForegroundColor Green
        }
      }
      catch {
        # Silently skip random assignment failures to avoid noise
        if ($DemoMode) {
          Write-Warning "Failed random assignment: $($user.displayName) to $($sp.displayName): $($_.Exception.Message)"
        }
      }
    }
  }
}

# Create Guest Users
if (-not $SkipGuestUsers) {
  Write-Host "`n👤 Creating Guest Users..." -ForegroundColor Cyan

  if ($UseBatch) {
    # Create batch requests for guest users
    $guestRequests = @()
    for ($i = 0; $i -lt $sampleGuestUsers.Count; $i++) {
      $guest = $sampleGuestUsers[$i]

      $guestBody = @{
        invitedUserEmailAddress = $guest.invitedUserEmailAddress
        invitedUserDisplayName  = $guest.invitedUserDisplayName
        inviteRedirectUrl       = $guest.inviteRedirectUrl
        invitedUserType         = $guest.invitedUserType
        sendInvitationMessage   = $guest.sendInvitationMessage
        invitedUserMessageInfo  = $guest.invitedUserMessageInfo
      }

      $guestRequests += @{
        id      = "guest-$i"
        method  = "POST"
        url     = "/invitations"
        body    = $guestBody
        headers = @{ "Content-Type" = "application/json" }
      }
    }

    $responses = Invoke-GraphBatchRequest -Requests $guestRequests -Headers $authHeaders

    foreach ($response in $responses) {
      if ($response.status -eq 201) {
        # Get the created user from the invitation response
        $invitedUser = $response.body.invitedUser

        # Add additional properties that were in our sample data
        $guestIndex = [int]($response.id -replace "guest-", "")
        if ($guestIndex -lt $sampleGuestUsers.Count) {
          $sampleGuest = $sampleGuestUsers[$guestIndex]

          # Update the user with additional properties
          try {
            $updateBody = @{
              companyName = $sampleGuest.companyName
              jobTitle    = $sampleGuest.jobTitle
              department  = $sampleGuest.department
            }

            Invoke-GraphApiRequest -Uri "$graphApiUri/users/$($invitedUser.id)" -Headers $authHeaders -Method PATCH -Body $updateBody

            # Store the updated user info
            $guestInfo = @{
              id                = $invitedUser.id
              userPrincipalName = $invitedUser.userPrincipalName
              displayName       = $invitedUser.displayName
              mail              = $invitedUser.mail
              userType          = $invitedUser.userType
              companyName       = $sampleGuest.companyName
              jobTitle          = $sampleGuest.jobTitle
              department        = $sampleGuest.department
            }

            $createdResources.GuestUsers += $guestInfo
            Write-Host "    ✅ Created guest: $($invitedUser.displayName) ($($sampleGuest.companyName))" -ForegroundColor Green
          }
          catch {
            Write-Warning "Failed to update guest user properties for $($invitedUser.displayName): $($_.Exception.Message)"
            # Still add the basic guest info
            $createdResources.GuestUsers += @{
              id                = $invitedUser.id
              userPrincipalName = $invitedUser.userPrincipalName
              displayName       = $invitedUser.displayName
              mail              = $invitedUser.mail
              userType          = $invitedUser.userType
            }
          }
        }
      }
      else {
        $guestIndex = [int]($response.id -replace "guest-", "")
        $guestEmail = if ($guestIndex -lt $sampleGuestUsers.Count) { $sampleGuestUsers[$guestIndex].invitedUserEmailAddress } else { "Unknown Guest" }
        Write-Warning "Failed to create guest user $guestEmail (Status: $($response.status)): $($response.body.error.message)"
      }
    }
  }
  else {
    # Sequential guest user creation
    foreach ($guest in $sampleGuestUsers) {
      try {
        if ($DemoMode) {
          Write-Host "  Creating guest user: $($guest.invitedUserDisplayName) ($($guest.invitedUserEmailAddress))" -ForegroundColor Yellow
        }

        $guestBody = @{
          invitedUserEmailAddress = $guest.invitedUserEmailAddress
          invitedUserDisplayName  = $guest.invitedUserDisplayName
          inviteRedirectUrl       = $guest.inviteRedirectUrl
          invitedUserType         = $guest.invitedUserType
          sendInvitationMessage   = $guest.sendInvitationMessage
          invitedUserMessageInfo  = $guest.invitedUserMessageInfo
        }

        $invitation = Invoke-GraphApiRequest -Uri "$graphApiUri/invitations" -Headers $authHeaders -Method POST -Body $guestBody
        $invitedUser = $invitation.invitedUser

        # Update the user with additional properties
        try {
          $updateBody = @{
            companyName = $guest.companyName
            jobTitle    = $guest.jobTitle
            department  = $guest.department
          }

          Invoke-GraphApiRequest -Uri "$graphApiUri/users/$($invitedUser.id)" -Headers $authHeaders -Method PATCH -Body $updateBody

          # Store the guest info
          $guestInfo = @{
            id                = $invitedUser.id
            userPrincipalName = $invitedUser.userPrincipalName
            displayName       = $invitedUser.displayName
            mail              = $invitedUser.mail
            userType          = $invitedUser.userType
            companyName       = $guest.companyName
            jobTitle          = $guest.jobTitle
            department        = $guest.department
          }

          $createdResources.GuestUsers += $guestInfo
          Write-Host "    ✅ Created guest: $($invitedUser.displayName) ($($guest.companyName))" -ForegroundColor Green
        }
        catch {
          Write-Warning "Failed to update guest user properties for $($invitedUser.displayName): $($_.Exception.Message)"
          # Still add the basic guest info
          $createdResources.GuestUsers += @{
            id                = $invitedUser.id
            userPrincipalName = $invitedUser.userPrincipalName
            displayName       = $invitedUser.displayName
            mail              = $invitedUser.mail
            userType          = $invitedUser.userType
          }
        }
      }
      catch {
        Write-Warning "Failed to create guest user $($guest.invitedUserEmailAddress): $($_.Exception.Message)"
      }
    }
  }
}

# Save created resources to JSON file for cleanup
if ($createdResources.Users.Count -gt 0 -or $createdResources.Groups.Count -gt 0 -or $createdResources.Applications.Count -gt 0 -or $createdResources.AppRoleAssignments.Count -gt 0 -or $createdResources.GuestUsers.Count -gt 0) {
  Save-CreatedResources -Resources $createdResources
}

# Summary
Write-Host $("=" * 50) -ForegroundColor Magenta
Write-Host "✨ Sample Data Creation Complete!" -ForegroundColor Magenta
Write-Host $("=" * 50) -ForegroundColor Magenta

Write-Host "`n📊 Summary of Created Resources:" -ForegroundColor Cyan
Write-Host "  👥 Users: $($createdResources.Users.Count)" -ForegroundColor Green
Write-Host "  📁 Groups: $($createdResources.Groups.Count)" -ForegroundColor Green
Write-Host "  🔧 Applications: $($createdResources.Applications.Count)" -ForegroundColor Green
Write-Host "  🔐 App Role Assignments: $($createdResources.AppRoleAssignments.Count)" -ForegroundColor Green
Write-Host "  👤 Guest Users: $($createdResources.GuestUsers.Count)" -ForegroundColor Green

Write-Host "`n🔍 Sample Queries You Can Now Test:" -ForegroundColor Cyan
Write-Host "  👥 USER QUERIES:" -ForegroundColor Yellow
Write-Host "    • Users by department: /users?`$filter=department eq 'Engineering'" -ForegroundColor White
Write-Host "    • Users by job title: /users?`$filter=jobTitle eq 'Software Developer'" -ForegroundColor White
Write-Host "    • Users by location: /users?`$filter=usageLocation eq 'US'" -ForegroundColor White
Write-Host "    • Users with manager role: /users?`$filter=contains(jobTitle, 'Manager')" -ForegroundColor White
Write-Host "    • Users in multiple departments: /users?`$filter=department in ('Engineering', 'IT Support')" -ForegroundColor White
Write-Host "    • Users with pagination: /users?`$top=20&`$skip=0&`$orderby=displayName" -ForegroundColor White

Write-Host "  👤 GUEST USER QUERIES:" -ForegroundColor Yellow
Write-Host "    • All guest users: /users?`$filter=userType eq 'Guest'" -ForegroundColor White
Write-Host "    • Guest users by company: /users?`$filter=userType eq 'Guest' and companyName eq 'Partner Corp'" -ForegroundColor White
Write-Host "    • Guest users by external domain: /users?`$filter=userType eq 'Guest' and startswith(mail, 'partner1.com')" -ForegroundColor White
Write-Host "    • Guest users created recently: /users?`$filter=userType eq 'Guest' and createdDateTime ge \$(Get-Date).AddDays(-1).ToString('yyyy-MM-ddTHH:mm:ssZ')" -ForegroundColor White
Write-Host "    • Guest users with PendingAcceptance: /users?`$filter=userType eq 'Guest' and externalUserState eq 'PendingAcceptance'" -ForegroundColor White

Write-Host "  📁 GROUP QUERIES:" -ForegroundColor Yellow
Write-Host "    • Security groups: /groups?`$filter=securityEnabled eq true" -ForegroundColor White
Write-Host "    • Mail-enabled groups: /groups?`$filter=mailEnabled eq true" -ForegroundColor White
Write-Host "    • Office 365 groups: /groups?`$filter=groupTypes/any(c:c eq 'Unified')" -ForegroundColor White
Write-Host "    • Groups with 'Team' in name: /groups?`$filter=contains(displayName, 'Team')" -ForegroundColor White
Write-Host "    • Groups with 'Talk' in name: /groups?`$search=`"displayName:Talk`"" -ForegroundColor White
Write-Host "    • Project groups: /groups?`$filter=startswith(displayName, 'Project')" -ForegroundColor White

Write-Host "  🔧 APPLICATION QUERIES:" -ForegroundColor Yellow
Write-Host "    • Applications with localhost URLs: /applications?`$filter=web/redirectUris/any(p:startswith(p, 'http://localhost'))" -ForegroundColor White
Write-Host "    • Web applications: /applications?`$filter=tags/any(t:t eq 'Web')" -ForegroundColor White
Write-Host "    • Mobile applications: /applications?`$filter=tags/any(t:t eq 'Mobile')" -ForegroundColor White
Write-Host "    • Demo applications: /applications?`$filter=startswith(displayName, 'Demo')" -ForegroundColor White

Write-Host "  🔐 APP ROLE ASSIGNMENT QUERIES:" -ForegroundColor Yellow
Write-Host "    • User's app assignments: /users/{user-id}/appRoleAssignments" -ForegroundColor White
Write-Host "    • Service principal assignments: /servicePrincipals/{sp-id}/appRoleAssignedTo" -ForegroundColor White
Write-Host "    • All app role assignments: /appRoleAssignments" -ForegroundColor White
Write-Host "    • Filter by resource: /users/{user-id}/appRoleAssignments?`$filter=resourceId eq '{sp-id}'" -ForegroundColor White
Write-Host "    • Assignment with details: /users/{user-id}/appRoleAssignments?`$expand=resource" -ForegroundColor White

Write-Host "  🔍 ADVANCED QUERIES:" -ForegroundColor Yellow
Write-Host "    • Complex user filter: /users?`$filter=department eq 'Engineering' and usageLocation eq 'US'&`$select=displayName,jobTitle,department" -ForegroundColor White
Write-Host "    • Group member count: /groups?`$expand=members(`$count=true)&`$select=displayName,members" -ForegroundColor White
Write-Host "    • Users created recently: /users?`$filter=createdDateTime ge \$(Get-Date).AddDays(-1).ToString('yyyy-MM-ddTHH:mm:ssZ')" -ForegroundColor White
Write-Host "    • Mixed user types: /users?`$filter=userType in ('Member', 'Guest')&`$select=displayName,userType,companyName" -ForegroundColor White
Write-Host "    • Batch request example: POST /`$batch with multiple queries" -ForegroundColor White

Write-Host "`n⚠️  Important Notes:" -ForegroundColor Yellow
Write-Host "  • All users have temporary passwords that must be changed on first login" -ForegroundColor Gray
Write-Host "  • Guest users are created with invitations that may need to be accepted" -ForegroundColor Gray
Write-Host "  • Run with -CleanupOnly to remove all sample data tracked in created-demo-resources.json" -ForegroundColor Gray
Write-Host "  • Run with -WhatIf to preview what would be cleaned up without deleting" -ForegroundColor Gray
Write-Host "  • Run with -UseBatch to use batch requests for faster resource creation" -ForegroundColor Gray
Write-Host "  • Run with -SkipGuestUsers to skip creating guest users" -ForegroundColor Gray
Write-Host "  • Created resources are saved to 'created-demo-resources.json' for precise cleanup" -ForegroundColor Gray
Write-Host "  • Some queries may take a few minutes to return results after creation" -ForegroundColor Gray
Write-Host "  • Batch requests can create up to 20 resources per request for improved performance" -ForegroundColor Gray

Write-Host "`n🎯 Your Microsoft Graph API demos are now ready!" -ForegroundColor Green
Write-Host "📁 Demo now includes: 75+ users, 60+ groups, 20+ applications, app role assignments, and guest users" -ForegroundColor Cyan
