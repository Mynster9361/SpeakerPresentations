# Get started with Azure Automation as your automation engine

## Who am I?

<div style="display: flex; align-items: center; flex-wrap: wrap;">
  <div style="flex: 1; min-width: 250px;">
    Hello there! I'm **Morten Mynster**, an automation enthusiast, coder, and proud family man. My IT journey began back in 2017, and since then, I've been on a mission to simplify the complex through scripting and automation. Whether it's crafting workflows, managing systems, or experimenting with new technologies, I thrive on turning challenges into opportunities for innovation.
  </div>
</div>

When I'm not writing code or tinkering in my homelab, I'm spending time with my amazing wife, our two kids, and our Disney-inspired dog, Mushu (yes, like the dragon from *Mulan*). Outside of work, you'll find me gaming, exploring new ideas, or enjoying quality time with my family.

### What I Work On
I dedicate my time to mastering:
- **PowerShell**: Automating tasks, managing systems, and making the impossible possible.
- **Python**: Building robust scripts and developing creative automation solutions.
- **Terraform**: Harnessing the power of infrastructure as code to tame the cloud.
- **Homelabbing**: Creating, breaking, and rebuilding home lab environments to push the boundaries of learning.

### Projects and Interests
I'm passionate about sharing my journey and insights through my blog, where I dive into topics like:
- **Automation tools and techniques**: From PowerShell modules to rest api's.
- **Scripting best practices**: Writing clean, efficient, and reusable code (or at least trying :D).
- **Microsoft Graph API**: Exploring advanced techniques for data manipulation and automation.


Let's connect on [LinkedIn](https://www.linkedin.com/in/mortenmynster/) and [GitHub](https://github.com/Mynster9361) ! I'm always excited to meet like-minded professionals and exchange ideas.

## Some nice to know things

### Setup Source Control in Azure Automation with GitHub PAT Token
1. Go to github
2. Press your profile picture up to the right
3. Go to settings
4. Go to developer settings at the bottom left
5. Go to personal access tokens and select tokens classic
6. Press generate new token - select Generate new token (classic)
7. Give it a name in the note field i recommend using the same name as the name of your azure automation account name
8. Set expiration you can max set it to 1 year in the calendar view or you can choose never expire (If you select never expire please update the token from time to time anyway as by default azures source control will only last 1 year anyway)
9. The token needs to have full permissions to the repo & admin:repo_hook (IT IS ESSENSTIAL THAT YOU SELECT THE TOP LEVEL) and not just everything below. 
10. Once that is done you should see your token copy it and note it down for later use
11. Click on Configure SSO and press on your organisation
12. Authenticate with your own account
13. Once done SSO should be enabled for your token
14. Open powershell and connect to Azure with this command
`Connect-AzAccount`
Find the subscription id for your Azure Automation Account and run this command
`Set-AzContext -Subscription "Your subscription ID"`
now run the following command to store your token in a secure string
`$pat = "Your token copied from earlier" | ConvertTo-SecureString -AsPlainText -Force`
Run the following command to setup Source control
`New-AzAutomationSourceControl -ResourceGroupName "Resource group name" -AutomationAccountName "your automation account name" -Name "The name for your source control" -RepoUrl "https://github.com/[Your repo name].git" -SourceType "GitHub" -FolderPath "/" -Branch "master/main" -AccessToken $pat`

Example is below for SpeakerPresentations 
```powershell
Connect-AzAccount

Set-AzContext -Subscription "Your subscription ID"

$pat = "Your token copied from earlier" | ConvertTo-SecureString -AsPlainText -Force

$params = @{
    ResourceGroupName     = "PDQ"
    AutomationAccountName = "PDQAutomation"
    Name                  = "TestSC"
    RepoUrl               = "https://github.com/Mynster9361/SpeakerPresentations.git"
    SourceType            = "GitHub"
    FolderPath            = "/2025/Move your automation to the cloud with Azure automation - PDQ/PowerShell/v5.1"
    Branch                = "main"
    AccessToken           = $pat
}


New-AzAutomationSourceControl @params
```
Once done you should see a new entry under source control in your Azure Automation account click it and enable Auto sync

### Internal Cmdlets
Reference: https://learn.microsoft.com/en-us/azure/automation/shared-resources/modules#internal-cmdlets

| Cmdlet                       | Description                                                                                                                               |
| ---------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| `Get-AutomationCertificate`  | Get-AutomationCertificate [-Name] <string> [<CommonParameters>]                                                                           |
| `Get-AutomationConnection`   | Get-AutomationConnection [-Name] <string> [-DoNotDecrypt] [<CommonParameters>]                                                            |
| `Get-AutomationPSCredential` | Get-AutomationPSCredential [-Name] <string> [<CommonParameters>]                                                                          |
| `Get-AutomationVariable`     | Get-AutomationVariable [-Name] <string> [-DoNotDecrypt] [<CommonParameters>]                                                              |
| `Set-AutomationVariable`     | Set-AutomationVariable [-Name] <string> -Value <Object> [<CommonParameters>]                                                              |
| `Start-AutomationRunbook`    | Start-AutomationRunbook [-Name] <string> [-Parameters <IDictionary>] [-RunOn <string>] [-JobId <guid>] [<CommonParameters>]               |
| `Wait-AutomationJob`         | Wait-AutomationJob -Id <guid[]> [-TimeoutInMinutes <int>] [-DelayInSeconds <int>] [-OutputJobsTransitionedToRunning] [<CommonParameters>] |


### Bugs / gotchas

#### Explicit assignments of access rights on path due to UAC

| Folder                                                                               | Permissions      |
| ------------------------------------------------------------------------------------ | ---------------- |
| `C:\ProgramData\AzureConnectedMachineAgent\Tokens`                                   | Read             |
| `C:\Packages\Plugins\Microsoft.Azure.Automation.HybridWorker.HybridWorkerForWindows` | Read and Execute |

#### Module dependencies
Upon installation of modules for other runtimes than 5.1 You will need to install the module you want to use along with all of it corresponding dependencies the import does not take into account any depenencies to other modules.
The exception is for 5.1 where you have the option to import/install from the PSGallery
^This limitation is only related to things that needs to run in Azure if done locally installs would normally install dependencies aswell^
Reference link for known issues: https://learn.microsoft.com/en-us/azure/automation/automation-runbook-types?tabs=lps74%2Cpy10#limitations-and-known-issues

#### Support PowerShell 7.2
It is supported in Azure Automation but PowerShell 7.2 is no longer supported by the PowerShell Product Group so support might vary
Referebce link: https://learn.microsoft.com/en-us/azure/automation/automation-runbook-types?tabs=lps72%2Cpy10#limitations-and-known-issues





## Questions & Feedback

I'd love to hear your feedback! Feel free to get in contact with me:
- Connect with me on [LinkedIn](https://www.linkedin.com/in/mortenmynster/)
- Check out my [GitHub](https://github.com/Mynster9361)
- Visit my [blog](https://mynster9361.github.io/)

Thank you for joining me!
