
# naming convention
resource "azurecaf_name" "bckp" {
  
  name          = var.settings.backup_vault_name
  resource_type = "azurerm_recovery_services_vault"
  prefixes      = var.global_settings.prefixes
  random_length = var.global_settings.random_length
  clean_input   = true
  passthrough   = var.global_settings.passthrough
  use_slug      = false #var.global_settings.use_slug
}

resource "azurerm_data_protection_backup_vault" "backup_vault" {
  name                = azurecaf_name.bckp.result 
  location            = var.location
  resource_group_name = var.resource_group_name
  datastore_type      = try(var.settings.datastore_type, "VaultStore")
  redundancy          = try(var.settings.redundancy, "LocallyRedundant")
  tags                = local.tags
  
  dynamic "identity" {
    for_each = lookup(var.settings, "enable_identity", false) == false ? [] : [1]

    content {
      type = "SystemAssigned"
    }
  }
}
