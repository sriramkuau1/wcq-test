# The following locals are used to build the map of Resource
# Groups to deploy.
locals {
  azurerm_resource_group_security = {
    for resource in module.security_resources.configuration.azurerm_resource_group :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Virtual
# Networks to deploy.
locals {
  azurerm_virtual_network_security = {
    for resource in module.security_resources.configuration.azurerm_virtual_network :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Subnets
# to deploy.
locals {
  azurerm_subnet_security = {
    for resource in module.security_resources.configuration.azurerm_subnet :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Network Security Groups
# to deploy.
locals {
  azurerm_network_security_group_security = {
    for resource in module.security_resources.configuration.azurerm_network_security_group :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Route Tables
# to deploy.
locals {
  azurerm_route_table_security = {
    for resource in module.security_resources.configuration.azurerm_route_table :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of subnet / Network Security Group associations
# to deploy.
locals {
  azurerm_subnet_network_security_group_association_security = {
    for resource in module.security_resources.configuration.azurerm_subnet_network_security_group_association :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of subnet / Route Table associations
# to deploy.
locals {
  azurerm_subnet_route_table_association_security = {
    for resource in module.security_resources.configuration.azurerm_subnet_route_table_association :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Storage
# Accounts to deploy.
locals {
  azurerm_storage_account_security = {
    for resource in module.security_resources.configuration.azurerm_storage_account :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_workspace_security = {
    for resource in module.security_resources.configuration.azurerm_log_analytics_workspace :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_solution_security = {
    for resource in module.security_resources.configuration.azurerm_log_analytics_solution :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_automation_account_security = {
    for resource in module.security_resources.configuration.azurerm_automation_account :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_linked_service_security = {
    for resource in module.security_resources.configuration.azurerm_log_analytics_linked_service :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Log
# Analytics workspaces to deploy.
locals {
  azurerm_log_analytics_linked_storage_account_security = {
    for resource in module.security_resources.configuration.azurerm_log_analytics_linked_storage_account :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Virtual
# Network Peerings to deploy.
locals {
  azurerm_virtual_network_peering_security = {
    for resource in module.security_resources.configuration.azurerm_virtual_network_peering :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of action
# groups to deploy.
locals {
  azurerm_monitor_action_group_security = {
    for resource in module.security_resources.configuration.azurerm_monitor_action_group :
    resource.resource_name => resource
    if resource.managed_by_module
  }
}

# The following locals are used to build the map of Security
# Insights Sentinel Onboarding to deploy.
locals {
  azurerm_sentinel_log_analytics_workspace_onboarding = {
    for resource in module.security_resources.configuration.azurerm_sentinel_log_analytics_workspace_onboarding :
    resource.resource_id => resource
    if resource.managed_by_module
  }
}
