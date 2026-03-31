#Prereqs:
# https://mynster9361.github.io/posts/LeastPrivilegedMSGraphSetup/

Install-Module -Name LeastPrivilegedMSGraph -Scope Currentuser


$tenantId = $env:tenantId
$clientId = $env:clientId
$clientSecret = $env:clientSecret | ConvertTo-SecureString -AsPlainText -Force
$daysToQuery = 5
$logAnalyticsWorkspaceId = $env:logAnalyticsWorkspaceId


Initialize-LogAnalyticsApi
# Shoutout to Friedrich Weinmann for his awesome module EntraAuth
Connect-EntraService -Service "LogAnalytics", "GraphBeta" -ClientID $clientId -TenantID $tenantId -ClientSecret $clientSecret

$graphApps = Get-AppRoleAssignment | Select-Object -First 5

$graphApps | Get-AppActivityData -WorkspaceId $logAnalyticsWorkspaceId -Days $daysToQuery -ThrottleLimit 20 -Maxentries 1000

$graphApps | Get-AppThrottlingData -WorkspaceId $logAnalyticsWorkspaceId -Days $daysToQuery

$graphApps | Get-PermissionAnalysis

Export-PermissionAnalysisReport -AppData $graphApps -OutputPath ".\report.html"
