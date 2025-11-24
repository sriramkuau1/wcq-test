resource "azurerm_resource_group" "identity" {
  for_each = local.azurerm_resource_group_identity

  provider = azurerm.identity

  # Mandatory resource attributes
  name     = each.value.template.name
  location = each.value.template.location
  tags     = each.value.template.tags
}

resource "azurerm_virtual_network" "identity" {
  for_each = local.azurerm_virtual_network_identity

  provider = azurerm.identity

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
    azurerm_resource_group.identity,
  ]
}

resource "azurerm_subnet" "identity" {
  for_each = local.azurerm_subnet_identity

  provider = azurerm.identity

  # Mandatory resource attributes
  name                 = each.value.template.name
  resource_group_name  = each.value.template.resource_group_name
  virtual_network_name = each.value.template.virtual_network_name
  address_prefixes     = each.value.template.address_prefixes

  # Optional resource attributes
  private_endpoint_network_policies             = each.value.template.private_endpoint_network_policies
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
    azurerm_resource_group.identity,
    azurerm_virtual_network.identity,
  ]
}

resource "azurerm_network_security_group" "identity" {
  for_each = local.azurerm_network_security_group_identity

  provider = azurerm.identity

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location

  # Optional resource attributes
  tags = each.value.template.tags

  # Dynamic configuration blocks
  dynamic "security_rule" {
    for_each = each.value.template.security_rule
    content {
      name                         = security_rule.value["name"]
      priority                     = security_rule.value["priority"]
      direction                    = security_rule.value["direction"]
      access                       = security_rule.value["access"]
      protocol                     = security_rule.value["protocol"]
      source_port_range            = security_rule.value["source_port_range"]
      source_port_ranges           = security_rule.value["source_port_ranges"]
      destination_port_range       = security_rule.value["destination_port_range"]
      destination_port_ranges      = security_rule.value["destination_port_ranges"]
      source_address_prefix        = security_rule.value["source_address_prefix"]
      source_address_prefixes      = security_rule.value["source_address_prefixes"]
      destination_address_prefix   = security_rule.value["destination_address_prefix"]
      destination_address_prefixes = security_rule.value["destination_address_prefixes"]
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.identity,
    azurerm_virtual_network.identity,
  ]
}

resource "azurerm_route_table" "identity" {
  for_each = local.azurerm_route_table_identity

  provider = azurerm.identity

  # Mandatory resource attributes
  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location

  # Optional resource attributes
  bgp_route_propagation_enabled = each.value.template.bgp_route_propagation_enabled
  tags                          = each.value.template.tags

  # Dynamic configuration blocks
  dynamic "route" {
    for_each = each.value.template.route
    content {
      name                   = route.value["name"]
      address_prefix         = route.value["address_prefix"]
      next_hop_type          = route.value["next_hop_type"]
      next_hop_in_ip_address = route.value["next_hop_in_ip_address"]
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.identity,
    azurerm_virtual_network.identity,
  ]
}

resource "azurerm_subnet_route_table_association" "identity" {
  for_each = local.azurerm_subnet_route_table_association_identity

  provider = azurerm.identity

  # Mandatory resource attributes
  subnet_id      = each.value.template.subnet_id
  route_table_id = each.value.template.route_table_id

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.identity,
    azurerm_subnet.identity,
    azurerm_route_table.identity,
  ]
}

resource "azurerm_subnet_network_security_group_association" "identity" {
  for_each = local.azurerm_subnet_network_security_group_association_identity

  provider = azurerm.identity

  # Mandatory resource attributes
  subnet_id                 = each.value.template.subnet_id
  network_security_group_id = each.value.template.network_security_group_id

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.identity,
    azurerm_subnet.identity,
    azurerm_network_security_group.identity,
  ]
}

resource "azurerm_virtual_network_peering" "identity" {
  for_each = local.azurerm_virtual_network_peering_identity

  provider = azurerm.identity

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
    azurerm_resource_group.identity,
    azurerm_virtual_network.identity,
  ]
}

resource "azurerm_key_vault" "identity" {
  for_each = local.azurerm_key_vault_identity

  provider = azurerm.identity

  # Mandatory resource attributes
  name                = each.value.template.name
  location            = each.value.template.location
  resource_group_name = each.value.template.resource_group_name

  # Optional resource attributes
  sku_name                   = each.value.template.sku_name
  tenant_id                  = each.value.template.tenant_id
  tags                       = each.value.template.tags
  purge_protection_enabled   = each.value.template.purge_protection_enabled


  # Set explicit dependency on Resource Group deployment
  depends_on = [
    azurerm_resource_group.identity,
  ]
}

resource "azurerm_virtual_hub_connection" "identity" {
  for_each = local.azurerm_virtual_hub_connection_identity

  provider = azurerm.identity

  # Mandatory resource attributes
  name                      = each.value.template.name
  virtual_hub_id            = each.value.template.virtual_hub_id
  remote_virtual_network_id = each.value.template.remote_virtual_network_id

  # Optional resource attributes
  internet_security_enabled = each.value.template.internet_security_enabled

  # Dynamic configuration blocks
  dynamic "routing" {
    for_each = each.value.template.routing
    content {
      # Optional attributes
      associated_route_table_id = lookup(routing.value, "associated_route_table_id", null)
      dynamic "propagated_route_table" {
        for_each = lookup(routing.value, "propagated_route_table", local.empty_list)
        content {
          # Optional attributes
          labels          = lookup(propagated_route_table.value, "labels", null)
          route_table_ids = lookup(propagated_route_table.value, "route_table_ids", null)
        }
      }
      dynamic "static_vnet_route" {
        for_each = lookup(routing.value, "static_vnet_route", local.empty_list)
        content {
          # Optional attributes
          name                = lookup(static_vnet_route.value, "name", null)
          address_prefixes    = lookup(static_vnet_route.value, "address_prefixes", null)
          next_hop_ip_address = lookup(static_vnet_route.value, "next_hop_ip_address", null)
        }
      }
    }
  }

  # Set explicit dependencies
  depends_on = [
    azurerm_resource_group.identity,
    azurerm_virtual_network.identity,
  ]

}

# Network interfaces for identity VMs
resource "azurerm_network_interface" "identity" {
  for_each = local.azurerm_network_interface_identity

  provider = azurerm.identity

  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location
  tags                = each.value.template.tags

  dynamic "ip_configuration" {
    for_each = each.value.template.ip_configuration
    content {
      name                          = ip_configuration.value.name
      subnet_id                     = ip_configuration.value.subnet_id
      private_ip_address_allocation = ip_configuration.value.private_ip_address_allocation
      private_ip_address            = ip_configuration.value.private_ip_address
    }
  }

  depends_on = [
    azurerm_resource_group.identity,
    azurerm_virtual_network.identity,
    azurerm_subnet.identity,
  ]
}

resource "azurerm_windows_virtual_machine" "identity" {
  for_each = local.azurerm_windows_virtual_machine_identity

  provider = azurerm.identity

  name                = each.value.template.name
  resource_group_name = each.value.template.resource_group_name
  location            = each.value.template.location
  size                = each.value.template.size
  admin_username      = each.value.template.admin_username
  admin_password      = each.value.template.admin_password

  network_interface_ids = each.value.template.network_interface_ids

  os_disk {
    caching              = each.value.template.os_disk.caching
    storage_account_type = each.value.template.os_disk.storage_account_type
    disk_size_gb         = try(each.value.template.os_disk.disk_size_gb, null)  # ADD: disk_size_gb if specified
  }

  source_image_reference {
    publisher = each.value.template.source_image_reference.publisher
    offer     = each.value.template.source_image_reference.offer
    sku       = each.value.template.source_image_reference.sku
    version   = each.value.template.source_image_reference.version
  }

  tags = each.value.template.tags

  depends_on = [
    azurerm_resource_group.identity,
    azurerm_virtual_network.identity,
    azurerm_subnet.identity,
    azurerm_network_interface.identity,  # ADD: Explicit dependency on NICs
  ]
}
