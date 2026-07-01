
deploy_core_landing_zones   = false
deploy_corp_landing_zones   = false
deploy_online_landing_zones = false

deploy_connectivity_resources = false
deploy_identity_resources     = false
deploy_management_resources   = true
deploy_landingzones_resources = false

# Configure the management resources settings.
configure_management_resources = {
  settings = {
    log_analytics = {
      enabled = true
      config = {
        retention_in_days                                 = 90
        enable_monitoring_for_vm                          = true
        enable_monitoring_for_vmss                        = true
        enable_solution_for_agent_health_assessment       = true
        enable_solution_for_anti_malware                  = true
        enable_solution_for_change_tracking               = true
        enable_solution_for_service_map                   = false
        enable_solution_for_sql_assessment                = false
        enable_solution_for_sql_vulnerability_assessment  = false
        enable_solution_for_sql_advanced_threat_detection = false
        enable_solution_for_updates                       = true
        enable_solution_for_vm_insights                   = true
        enable_solution_for_container_insights            = true
        enable_sentinel                                   = false
      }
    }
    spoke_networks = [
      {
        identifier = "vnet_australiaeast"
        enabled    = true
        config = {
          address_space                = ["10.101.0.0/24", ]
          location                     = "australiaeast"
          link_to_ddos_protection_plan = false
          dns_servers                  = []
          subnets = [
            {
              name                          = "Management"
              address_prefixes              = ["10.101.0.0/25"]
              bgp_route_propagation_enabled = false
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
                  source_address_prefix      = "VirtualNetwork"
                  destination_address_prefix = "VirtualNetwork"
                },
                {
                  name                       = "AllowOutbound"
                  priority                   = 100
                  direction                  = "Outbound"
                  access                     = "Allow"
                  protocol                   = "*"
                  source_port_range          = "*"
                  destination_port_range     = "*"
                  source_address_prefix      = "VirtualNetwork"
                  destination_address_prefix = "VirtualNetwork"
                }
              ]
              delegations       = []
              service_endpoints = []
            }
          ]
          hub_network_id               = "/subscriptions/1336f5fd-b39b-4d15-aa73-7e1ed659b9c1/resourceGroups/arg-syd-plat-conn-connectivity/providers/Microsoft.Network/virtualNetworks/vnt-syd-plat-conn-10.100.0.0_16"
          allow_virtual_network_access = true
          allow_forwarded_traffic      = true
          use_remote_gateways          = false
        }
      }
    ]
    action_group_name      = "platformActionGroup"
    action_group_shortname = "platActnGrp"
    contact_email          = "test@test.com"
  }

  location = "australiaeast"
  tags = {
    applicationName    = "Platform Management"
    contactEmail       = "test@test.com"
    costCenter         = ""
    criticality        = "Tier0"
    dataClassification = "Internal"
    owner              = "Core Infrastructure"
    environment        = "Production"
  }
  advanced = {
    resource_prefix = "plat-mgmt"
    custom_azure_backup_geo_codes = {
      australiaeast      = "syd"
      australiasoutheast = "mel"
    }
  }
}
