
deploy_core_landing_zones   = false
deploy_corp_landing_zones   = false
deploy_online_landing_zones = false

deploy_connectivity_resources = false
deploy_identity_resources     = false
deploy_management_resources   = false
deploy_landingzones_resources = true

subscription_id_landingzones = ""

# Configure the landing zone resources settings.
configure_landingzones_resources = {
  settings = {
    landingzones = {
      enabled = true
      config = {
        amount                 = 1000
        start_date             = "2023-08-01T00:00:00Z"
        end_date               = "2024-08-01T00:00:00Z"
        subscription_name      = "sub-lz-corp-avd-01"
        action_group_name      = "AVD-Action-Group"
        action_group_shortname = "AVD-AG"
        enable_notifications   = true
        threshold              = "100.0"
        operator               = "GreaterThan"
        contact_email          = "test@test.com"
      }
    }
    rbac = [
      {
        role_definition_id = "/subscriptions/***/providers/Microsoft.Authorization/roleDefinitions/***"
        principal_id = ""
      },
      {
        role_definition_id = "/subscriptions/***/providers/Microsoft.Authorization/roleDefinitions/***"
        principal_id = ""
      }
    ]
    spoke_networks = [
      {
        identifier = "vnet_australiaeast"
        enabled    = true
        config = {
          address_space                = ["10.103.0.0/24", ]
          location                     = "australiaeast"
          link_to_ddos_protection_plan = false
          dns_servers                  = []
          subnets = [
            {
              name                          = "avd"
              address_prefixes              = ["10.103.0.0/25"]
              disable_bgp_route_propagation = true
              routes                        = []
              rules = [
                {
                  name                       = "AllowInbound"
                  priority                   = 100
                  direction                  = "Inbound"
                  access                     = "Allow"
                  protocol                   = "*"
                  source_port_range          = "*"
                  destination_port_range     = "*"
                  source_address_prefix      = "*"
                  destination_address_prefix = "*"
                },
                {
                  name                       = "AllowOutbound"
                  priority                   = 100
                  direction                  = "Outbound"
                  access                     = "Allow"
                  protocol                   = "*"
                  source_port_range          = "*"
                  destination_port_range     = "*"
                  source_address_prefix      = "*"
                  destination_address_prefix = "*"
                }
              ]
              delegations       = []
              service_endpoints = []
            },
            {
              name                          = "pe"
              address_prefixes              = ["10.103.0.128/25"]
              disable_bgp_route_propagation = true
              routes                        = []
              rules = [
                {
                  name                       = "AllowInbound"
                  priority                   = 100
                  direction                  = "Inbound"
                  access                     = "Allow"
                  protocol                   = "*"
                  source_port_range          = "*"
                  destination_port_range     = "*"
                  source_address_prefix      = "*"
                  destination_address_prefix = "*"
                },
                {
                  name                       = "AllowOutbound"
                  priority                   = 100
                  direction                  = "Outbound"
                  access                     = "Allow"
                  protocol                   = "*"
                  source_port_range          = "*"
                  destination_port_range     = "*"
                  source_address_prefix      = "*"
                  destination_address_prefix = "*"
                }
              ]
              delegations       = []
              service_endpoints = []
            }
          ]
          hub_network_id               = "resource_id"
          allow_virtual_network_access = true
          allow_forwarded_traffic      = true
          use_remote_gateways          = false
        }
      }
    ]
  }

  location = "australiaeast"
  tags = {
    applicationName    = "AVD Management"
    contactEmail       = "test@test.com"
    costCenter         = ""
    criticality        = "Tier0"
    dataClassification = "Internal"
    owner              = "Core Infrastructure"
    environment        = "Production"
  }
  advanced = {
    resource_prefix = "lz-avd"
    custom_azure_backup_geo_codes = {
      australiaeast      = "syd"
      australiasoutheast = "mel"
    }
  }
}
