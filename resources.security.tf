resource "azurerm_resource_group" "security" {
  for_each = local.azurerm_resource_group_security

  provider = azurerm.security

  # Mandatory resource attributes
  name     = each.value.template.name
  location = each.value.template.location
  tags     = each.value.template.tags
}

resource "azurerm_virtual_network" "security" {
  for_each = local.azurerm_virtual_network_security

  provider = azurerm.security

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  address_space       = each.value.template.address_space
  location            = each.value.template.location

  # Optional resource attributes
  bgp_community = each.value.template.bgp_community
  dns_servers   = each.value.template.dns_servers
  tags          = each.value.template.tags

  # Dynamic configuration blocks
  # Subnets excluded (use azurerm_subnet resource)
  dynamic "ddos_protection_plan" {
    for_each = each.value.template.ddos_protection_plan
    content {
      id     = ddos_protection_plan.value["id"]
      enable = ddos_protection_plan.value["enable"]
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.security,
  ]
}

resource "azurerm_subnet" "security" {
  for_each = local.azurerm_subnet_security

  provider = azurerm.security

  # Mandatory resource attributes
  name                 = each.value.template.name
  resource_group_name  = each.value.template.resource_group_name
  virtual_network_name = each.value.template.virtual_network_name
  address_prefixes     = each.value.template.address_prefixes

  # Optional resource attributes
  # private_endpoint_network_policies_enabled     = each.value.template.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.template.private_link_service_network_policies_enabled
  service_endpoints                             = each.value.template.service_endpoints
  service_endpoint_policy_ids                   = each.value.template.service_endpoint_policy_ids

  # Dynamic configuration blocks
  # Subnets excluded (use azurerm_subnet resource)
  dynamic "delegation" {
    for_each = each.value.template.delegation
    content {
      name = delegation.value["name"]

      dynamic "service_delegation" {
        for_each = delegation.value["service_delegation"]
        content {
          name    = service_delegation.value["name"]
          actions = try(service_delegation.value["actions"], null)
        }
      }
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.security,
    azurerm_virtual_network.security,
  ]
}

resource "azurerm_network_security_group" "security" {
  for_each = local.azurerm_network_security_group_security

  provider = azurerm.security

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location

  # Optional resource attributes
  tags          = each.value.template.tags

  # Dynamic configuration blocks
  dynamic "security_rule" {
    for_each = each.value.template.security_rule
    content {
      name                        = security_rule.value["name"]
      priority                    = security_rule.value["priority"]
      direction                   = security_rule.value["direction"]
      access                      = security_rule.value["access"]
      protocol                    = security_rule.value["protocol"]
      source_port_range           = security_rule.value["source_port_range"]
      destination_port_range      = security_rule.value["destination_port_range"]
      source_address_prefix       = security_rule.value["source_address_prefix"]
      destination_address_prefix  = security_rule.value["destination_address_prefix"]
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.security,
    azurerm_virtual_network.security,
  ]
}

resource "azurerm_route_table" "security" {
  for_each = local.azurerm_route_table_security

  provider = azurerm.security

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location

  # Optional resource attributes
  # disable_bgp_route_propagation = each.value.template.disable_bgp_route_propagation
  tags                          = each.value.template.tags

  # Dynamic configuration blocks
  dynamic "route" {
    for_each = each.value.template.route
    content {
      name                    = route.value["name"]
      address_prefix          = route.value["address_prefix"]
      next_hop_type           = route.value["next_hop_type"]
      next_hop_in_ip_address  = route.value["next_hop_in_ip_address"]
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.management,
    azurerm_virtual_network.management,
  ]
}

resource "azurerm_subnet_route_table_association" "security" {
  for_each = local.azurerm_subnet_route_table_association_security

  provider = azurerm.security

  # Mandatory resource attributes
  subnet_id         = each.value.template.subnet_id
  route_table_id    = each.value.template.route_table_id

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.security,
    azurerm_subnet.security,
    azurerm_route_table.security,
  ]
}

resource "azurerm_subnet_network_security_group_association" "security" {
  for_each = local.azurerm_subnet_network_security_group_association_security

  provider = azurerm.security

  # Mandatory resource attributes
  subnet_id                     = each.value.template.subnet_id
  network_security_group_id     = each.value.template.network_security_group_id

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.security,
    azurerm_subnet.security,
    azurerm_network_security_group.security,
  ]
}

resource "azurerm_storage_account" "security" {
  for_each = local.azurerm_storage_account_security

  provider = azurerm.security

  # Mandatory resource attributes
  name                = each.value.template.name
  location            = each.value.template.location
  resource_group_name = each.value.template.resource_group_name

  # Optional resource attributes
  account_tier                       = each.value.template.account_tier
  account_replication_type           = each.value.template.account_replication_type
  tags                               = each.value.template.tags

  # Set explicit dependency on Resource Group deployment
  depends_on = [
    azurerm_resource_group.security,
  ]

}

resource "azurerm_log_analytics_workspace" "security" {
  for_each = local.azurerm_log_analytics_workspace_security

  provider = azurerm.security

  # Mandatory resource attributes
  name                = each.value.template.name
  location            = each.value.template.location
  resource_group_name = each.value.template.resource_group_name

  # Optional resource attributes
  sku                                = each.value.template.sku
  retention_in_days                  = each.value.template.retention_in_days
  daily_quota_gb                     = each.value.template.daily_quota_gb
  cmk_for_query_forced               = each.value.template.cmk_for_query_forced
  internet_ingestion_enabled         = each.value.template.internet_ingestion_enabled
  internet_query_enabled             = each.value.template.internet_query_enabled
  reservation_capacity_in_gb_per_day = each.value.template.reservation_capacity_in_gb_per_day
  tags                               = each.value.template.tags

  # allow_resource_only_permissions = each.value.template.allow_resource_only_permissions # Available only in v3.36.0 onwards

  # Set explicit dependency on Resource Group deployment
  depends_on = [
    azurerm_resource_group.security,
  ]

}

resource "azurerm_log_analytics_solution" "security" {
  for_each = local.azurerm_log_analytics_solution_security

  provider = azurerm.security

  # Mandatory resource attributes
  solution_name         = each.value.template.solution_name
  location              = each.value.template.location
  resource_group_name   = each.value.template.resource_group_name
  workspace_resource_id = each.value.template.workspace_resource_id
  workspace_name        = each.value.template.workspace_name

  plan {
    publisher = each.value.template.plan.publisher
    product   = each.value.template.plan.product
  }

  # Optional resource attributes
  tags = each.value.template.tags

  # Set explicit dependency on Resource Group, Log Analytics
  # workspace and Automation Account to fix issue #109.
  # Ideally we would limit to specific solutions, but the
  # depends_on block only supports static values.
  depends_on = [
    azurerm_resource_group.security,
    azurerm_log_analytics_workspace.security,
    # azurerm_automation_account.security,
    # azurerm_log_analytics_linked_service.security,
    azurerm_log_analytics_linked_storage_account.security,
    azurerm_storage_account.security
  ]

}

resource "azurerm_log_analytics_linked_storage_account" "security" {
  for_each = local.azurerm_log_analytics_linked_storage_account_security

  provider = azurerm.security

  # Mandatory resource attributes
  data_source_type        = each.value.template.data_source_type
  resource_group_name     = each.value.template.resource_group_name
  workspace_resource_id   = each.value.template.workspace_resource_id
  storage_account_ids     = each.value.template.storage_account_ids

  # Set explicit dependency on Resource Group, and Log Analytics workspace
  depends_on = [
    azurerm_resource_group.security,
    azurerm_log_analytics_workspace.security,
    azurerm_storage_account.security
  ]

}

resource "azurerm_virtual_network_peering" "security" {
  for_each = local.azurerm_virtual_network_peering_security

  provider = azurerm.security

  # Mandatory resource attributes
  name                      = each.value.template.name
  resource_group_name       = each.value.template.resource_group_name
  virtual_network_name      = each.value.template.virtual_network_name
  remote_virtual_network_id = each.value.template.remote_virtual_network_id

  # Optional resource attributes
  allow_virtual_network_access = each.value.template.allow_virtual_network_access
  allow_forwarded_traffic      = each.value.template.allow_forwarded_traffic
  allow_gateway_transit        = each.value.template.allow_gateway_transit
  use_remote_gateways          = each.value.template.use_remote_gateways

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.security,
    azurerm_virtual_network.security,
  ]
}

resource "azurerm_sentinel_log_analytics_workspace_onboarding" "security" {
  for_each = local.azurerm_sentinel_log_analytics_workspace_onboarding

  provider = azurerm.security

  # Mandatory resource attributes
  workspace_id = each.value.template.workspace_id
  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.security,
    azurerm_log_analytics_workspace.security,
  ]
}
