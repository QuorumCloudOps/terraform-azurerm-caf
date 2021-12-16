resource "azuread_group" "group" {
  display_name            = var.global_settings.passthrough ? format("%s", var.azuread_groups.name) : format("%s%s", try(format("%s-", var.global_settings.prefixes.0), ""), var.azuread_groups.name)
  description             = lookup(var.azuread_groups, "description", null)
  prevent_duplicate_names = lookup(var.azuread_groups, "prevent_duplicate_names", null)

  owners = concat(try(values(local.owners), null), values(local.service_principals), tolist([try(var.client_config.logged_user_objectId, null)]))
}


data "azuread_user" "owners" {
  count               = length(var.azuread_groups.owners.user_principal_names)
  user_principal_name = try(var.azuread_groups.owners.user_principal_names[count.index], null)
}

locals {
  owners = {
    for owner in data.azuread_user.owners : owner.user_principal_name => owner.id
  }

  service_principals = {
    for sp_key in toset(var.azuread_groups.owners.service_principal_keys) : sp_key => var.azuread_service_principals[sp_key].object_id
  }
}

