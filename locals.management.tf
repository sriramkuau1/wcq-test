# The following locals are used to build the map of Resource
# Groups to deploy.
locals {
  azurerm_resource_group_management = {
    for resource in module.management_resources.configuration.azurerm_resource_group :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Virtual
# Networks to deploy.
locals {
  azurerm_virtual_network_management = {
    for resource in module.management_resources.configuration.azurerm_virtual_network :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Subnets
# to deploy.
locals {
  azurerm_subnet_management = {
    for resource in module.management_resources.configuration.azurerm_subnet :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Network Security Groups
# to deploy.
locals {
  azurerm_network_security_group_management = {
    for resource in module.management_resources.configuration.azurerm_network_security_group :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Route Tables
# to deploy.
locals {
  azurerm_route_table_management = {
    for resource in module.management_resources.configuration.azurerm_route_table :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of subnet / Network Security Group associations 
# to deploy.
locals {
  azurerm_subnet_network_security_group_association_management = {
    for resource in module.management_resources.configuration.azurerm_subnet_network_security_group_association :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of subnet / Route Table associations
# to deploy.
locals {
  azurerm_subnet_route_table_association_management = {
    for resource in module.management_resources.configuration.azurerm_subnet_route_table_association :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of the Key
# Vault Secret for the VM Password to deploy.
locals {
  azurerm_key_vault_secret_management = {
    for resource in module.management_resources.configuration.azurerm_key_vault_secret :
    resource.resource_name => resource
    if resource.managed_by_module
  }
}

data "azurerm_key_vault_secret" "management" {
  for_each = local.azurerm_key_vault_secret_management

  name         = each.value.template.name
  key_vault_id = each.value.template.key_vault_id == "" ? try(module.identity_resources.configuration.azurerm_key_vault[0].resource_id,"") : each.value.template.key_vault_id
}

# The following locals are used to build the map of AVD
# Session Host Network Interfaces to deploy.
locals {
  azurerm_network_interface_management = module.management_resources.configuration.azurerm_network_interface
}

# The following locals are used to build the map of AVD
# Session Hosts to deploy.
locals {
  azurerm_windows_virtual_machine_management = module.management_resources.configuration.azurerm_windows_virtual_machine
}

# The following locals are used to build the map of Storage 
# Accounts to deploy.
locals {
  azurerm_storage_account_management = {
    for resource in module.management_resources.configuration.azurerm_storage_account :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_workspace_management = {
    for resource in module.management_resources.configuration.azurerm_log_analytics_workspace :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_solution_management = {
    for resource in module.management_resources.configuration.azurerm_log_analytics_solution :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_automation_account_management = {
    for resource in module.management_resources.configuration.azurerm_automation_account :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_linked_service_management = {
    for resource in module.management_resources.configuration.azurerm_log_analytics_linked_service :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_linked_storage_account_management = {
    for resource in module.management_resources.configuration.azurerm_log_analytics_linked_storage_account :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Virtual
# Network Peerings to deploy.
locals {
  azurerm_virtual_network_peering_management = {
    for resource in module.management_resources.configuration.azurerm_virtual_network_peering :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of action
# groups to deploy.
locals {
  azurerm_monitor_action_group_management = {
    for resource in module.management_resources.configuration.azurerm_monitor_action_group :
    resource.resource_name => resource
    if resource.managed_by_module
  }
}
