variable "tenant_id" {
  description = "Entra ID tenant ID the demo resources are created in."
  type        = string
}

variable "subscription_id" {
  description = "Azure subscription ID the demo resources are created in."
  type        = string
}

variable "location" {
  description = "Azure region for the demo resources."
  type        = string
  default     = "West Europe"
}

variable "prefix" {
  description = "Prefix used for naming all demo resources."
  type        = string
  default     = "appauth-demo"
}

# Used to build the federated credential subject for the "Federated credentials" demo.
# Example subject: repo:Mynster9361/SpeakerPresentations:ref:refs/heads/main
variable "github_org" {
  description = "GitHub org/user used for the GitHub Actions federated credential demo."
  type        = string
  default     = "Mynster9361"
}

variable "github_repo" {
  description = "GitHub repo used for the GitHub Actions federated credential demo."
  type        = string
  default     = "SpeakerPresentations"
}

variable "github_branch" {
  description = "Branch used for the GitHub Actions federated credential demo subject."
  type        = string
  default     = "main"
}
