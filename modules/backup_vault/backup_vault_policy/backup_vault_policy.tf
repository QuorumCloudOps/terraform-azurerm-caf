resource "azurerm_data_protection_backup_policy_blob_storage" "backup_vault_policy" {
  
  name                                             = var.backup_vault_policy.name
  backup_vault_name                                = azurerm_data_protection_backup_vault.backup_vault.name
  retention_duration                               = try(var.retention_duration, "P30D")
}
