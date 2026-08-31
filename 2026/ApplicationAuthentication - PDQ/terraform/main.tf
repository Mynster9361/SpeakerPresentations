data "azuread_client_config" "current" {}

# Microsoft Graph service principal - used below to grant app roles (Graph API permissions).
data "azuread_service_principal" "msgraph" {
  client_id = "00000003-0000-0000-c000-000000000000"
}

resource "azurerm_resource_group" "demo" {
  name     = "${var.prefix}-rg"
  location = var.location
}

# ---------------------------------------------------------------------------
# App Registration - Secret authentication
# ---------------------------------------------------------------------------

resource "azuread_application" "secret_demo" {
  display_name = "${var.prefix}-secret-auth"
  owners       = [data.azuread_client_config.current.object_id]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All (Application)
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "secret_demo" {
  client_id = azuread_application.secret_demo.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

resource "time_rotating" "secret_demo" {
  rotation_days = 90 # short-lived on purpose, this is the whole point of the demo
}

resource "azuread_application_password" "secret_demo" {
  application_id = azuread_application.secret_demo.id
  display_name   = "demo-secret"
  end_date       = time_rotating.secret_demo.rotation_rfc3339
}

# ---------------------------------------------------------------------------
# App Registration - Certificate authentication
# ---------------------------------------------------------------------------

resource "azuread_application" "cert_demo" {
  display_name = "${var.prefix}-cert-auth"
  owners       = [data.azuread_client_config.current.object_id]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All (Application)
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "cert_demo" {
  client_id = azuread_application.cert_demo.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

# Self-signed cert generated for the demo only - do this with a CA-issued cert in real life.
resource "tls_private_key" "cert_demo" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "cert_demo" {
  private_key_pem = tls_private_key.cert_demo.private_key_pem

  subject {
    common_name = "${var.prefix}-cert-auth"
  }

  validity_period_hours = 24 * 30 # 30 days
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
  ]
}

# Written to disk so the PowerShell demo script can load them - see .gitignore, never commit these.
resource "local_sensitive_file" "cert_demo_key" {
  content         = tls_private_key.cert_demo.private_key_pem
  filename        = "${path.module}/generated/cert-demo.key.pem"
  file_permission = "0600"
}

resource "local_file" "cert_demo_cert" {
  content  = tls_self_signed_cert.cert_demo.cert_pem
  filename = "${path.module}/generated/cert-demo.cert.pem"
}

resource "azuread_application_certificate" "cert_demo" {
  application_id = azuread_application.cert_demo.id
  type           = "AsymmetricX509Cert"
  encoding       = "pem"
  value          = tls_self_signed_cert.cert_demo.cert_pem
  end_date       = tls_self_signed_cert.cert_demo.validity_end_time
}

# ---------------------------------------------------------------------------
# App Registration - Federated credentials (workload identity federation)
# ---------------------------------------------------------------------------

resource "azuread_application" "federated_demo" {
  display_name = "${var.prefix}-federated-auth"
  owners       = [data.azuread_client_config.current.object_id]

  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph

    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All (Application)
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "federated_demo" {
  client_id = azuread_application.federated_demo.client_id
  owners    = [data.azuread_client_config.current.object_id]
}

# Trusts tokens issued by GitHub Actions for this repo/branch - no secret ever leaves GitHub.
resource "azuread_application_federated_identity_credential" "github_actions" {
  application_id = azuread_application.federated_demo.id
  display_name   = "github-actions-${var.github_branch}"
  description    = "Federated credential trusting GitHub Actions OIDC tokens for ${var.github_org}/${var.github_repo}@${var.github_branch}"
  audiences      = ["api://AzureADTokenExchange"]
  issuer         = "https://token.actions.githubusercontent.com"
  subject        = "repo:${var.github_org}/${var.github_repo}:ref:refs/heads/${var.github_branch}"
}

# ---------------------------------------------------------------------------
# Managed Identity + permission assignment
# ---------------------------------------------------------------------------

resource "azurerm_user_assigned_identity" "demo" {
  name                = "${var.prefix}-mi"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
}

# Azure RBAC permission on the resource group - the "normal" case, works out of the box in the portal.
resource "azurerm_role_assignment" "demo_reader" {
  scope                = azurerm_resource_group.demo.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.demo.principal_id
}

# Graph API permission for the managed identity - the portal can't do this, has to be app role
# assignment against the Graph service principal, using the MI's principal id as the client.
resource "azuread_app_role_assignment" "demo_mi_graph" {
  app_role_id         = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All (Application)
  principal_object_id = azurerm_user_assigned_identity.demo.principal_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}

# System-assigned identity example - a resource that actually uses its MI at runtime.
resource "azurerm_automation_account" "demo" {
  name                = "${var.prefix}-aa"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  sku_name            = "Basic"

  identity {
    type = "SystemAssigned"
  }
}

resource "azuread_app_role_assignment" "demo_aa_graph" {
  app_role_id         = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All (Application)
  principal_object_id = azurerm_automation_account.demo.identity[0].principal_id
  resource_object_id  = data.azuread_service_principal.msgraph.object_id
}
