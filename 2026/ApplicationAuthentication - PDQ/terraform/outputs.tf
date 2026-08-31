output "tenant_id" {
  value = var.tenant_id
}

# --- Secret auth demo ---

output "secret_demo_client_id" {
  value = azuread_application.secret_demo.client_id
}

output "secret_demo_client_secret" {
  value     = azuread_application_password.secret_demo.value
  sensitive = true
}

# --- Certificate auth demo ---

output "cert_demo_client_id" {
  value = azuread_application.cert_demo.client_id
}

output "cert_demo_key_path" {
  value = local_sensitive_file.cert_demo_key.filename
}

output "cert_demo_cert_path" {
  value = local_file.cert_demo_cert.filename
}

# --- Federated credential demo ---

output "federated_demo_client_id" {
  value = azuread_application.federated_demo.client_id
}

# --- Managed identity demo ---

output "user_assigned_identity_client_id" {
  value = azurerm_user_assigned_identity.demo.client_id
}

output "user_assigned_identity_principal_id" {
  value = azurerm_user_assigned_identity.demo.principal_id
}

output "automation_account_principal_id" {
  value = azurerm_automation_account.demo.identity[0].principal_id
}
