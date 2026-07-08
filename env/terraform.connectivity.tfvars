
deploy_core_landing_zones   = false
deploy_corp_landing_zones   = false
deploy_online_landing_zones = false

deploy_connectivity_resources = true
deploy_identity_resources     = true
deploy_management_resources   = true
deploy_landingzones_resources = false

# Configure the connectivity resources settings.
configure_connectivity_resources = {
  settings = {
    # Traditional hub VNet disabled — using Virtual WAN secured hub architecture
    hub_networks = []

    # Virtual WAN secured hub — Australia East
    vwan_hub_networks = [
      {
        enabled = true
        config = {
          address_prefix = "10.100.0.0/23"
          location       = "australiaeast"
          sku            = "Standard"
          routes         = []

          # ExpressRoute Gateway — ErGw2AZ equivalent (2 scale units = 2 Gbps)
          expressroute_gateway = {
            enabled = true # TEST: enabled for deployment test (~$300+/mo)
            config = {
              scale_unit = 2
            }
          }

          # VPN Gateway — VpnGw2AZ equivalent (2 scale units, AZ-enabled)
          vpn_gateway = {
            enabled = true # TEST: enabled for deployment test (~$250+/mo)
            config = {
              bgp_settings       = []
              routing_preference = "Microsoft Network"
              scale_unit         = 2
            }
          }

          # Azure Firewall Premium — TLS inspection + IDPS
          azure_firewall = {
            enabled = true # TEST: enabled for deployment test (~$900+/mo + processing)
            config = {
              enable_dns_proxy         = true
              dns_servers              = []
              sku_tier                 = "Premium"
              base_policy_id           = "" # EPAC will manage firewall policy lifecycle
              private_ip_ranges        = []
              threat_intelligence_mode = "Alert"
              threat_intelligence_allowlist = []
              availability_zones = {
                zone_1 = true
                zone_2 = true
                zone_3 = true
              }
              # No rule collection groups — EPAC owns all firewall rules
              firewall_policy_rule_collection_groups = []
            }
          }

          # Routing Intent — routes all private + internet traffic through Firewall
          virtual_hub_routing_intent = {
            enabled = false # Disabled — next_hop requires Firewall resource ID which creates circular dependency
            routing_policies = [
              {
                name         = "PrivateTrafficPolicy"
                destinations = ["PrivateTraffic"]
                next_hop     = "" # Auto-resolved to Firewall resource ID by module
              },
              {
                name         = "InternetTrafficPolicy"
                destinations = ["Internet"]
                next_hop     = "" # Auto-resolved to Firewall resource ID by module
              }
            ]
          }

          # Spoke connections — add spoke VNet resource IDs as they are created
          spoke_virtual_network_resource_ids        = []
          secure_spoke_virtual_network_resource_ids = []
          enable_virtual_hub_connections            = false
        }
      }
    ]
    ddos_protection_plan = {
      enabled = false
      config = {
        location = "australiaeast"
      }
    }
    dns = {
      enabled = true
      config = {
        location = null
        enable_private_link_by_service = {
          azure_api_management                 = true
          azure_app_configuration_stores       = true
          azure_arc                            = true
          azure_automation_dscandhybridworker  = true
          azure_automation_webhook             = true
          azure_backup                         = true
          azure_batch_account                  = true
          azure_bot_service_bot                = true
          azure_bot_service_token              = true
          azure_cache_for_redis                = true
          azure_cache_for_redis_enterprise     = true
          azure_container_registry             = true
          azure_cosmos_db_cassandra            = true
          azure_cosmos_db_gremlin              = true
          azure_cosmos_db_mongodb              = true
          azure_cosmos_db_sql                  = true
          azure_cosmos_db_table                = true
          azure_databricks                     = false //Potential impacts to the Azure Databricks portal (https://accounts.azuredatabricks.net/login) for public Azure Databricks.
          azure_data_explorer                  = true
          azure_data_factory                   = false //Enabling this will impact the public Data Factory portal (https://adf.azure.com/en/) for public Azure Data Factory resources.
          azure_data_factory_portal            = false //Enabling this will impact the public Data Factory portal (https://adf.azure.com/en/) for public Azure Data Factory resources
          azure_data_health_data_services      = true
          azure_data_lake_file_system_gen2     = true
          azure_database_for_mariadb_server    = true
          azure_database_for_mysql_server      = true
          azure_database_for_postgresql_server = true
          azure_digital_twins                  = true
          azure_event_grid_domain              = false //Affects Push services with private link services, Pull services remain unaffected
          azure_event_grid_topic               = false //Affects Push services with private link services, Pull services remain unaffected
          azure_event_hubs_namespace           = true
          azure_file_sync                      = true
          azure_hdinsights                     = true
          azure_iot_dps                        = true
          azure_iot_hub                        = true
          azure_key_vault                      = true
          azure_key_vault_managed_hsm          = true
          azure_kubernetes_service_management  = true
          azure_machine_learning_workspace     = true
          azure_managed_disks                  = true
          azure_media_services                 = true
          azure_migrate                        = true
          azure_monitor                        = false //Azure Monitor when enabled on private links has specific considerations due to its use of shared endpoints that are not resource-specific. This unique requirement needs to be managed carefully. For more information, see https://learn.microsoft.com/en-us/azure/azure-monitor/logs/private-link-security#azure-monitor-private-links-rely-on-your-dns.
          azure_purview_account                = true
          azure_purview_studio                 = false //Affects Purview public web portal if not configured to use private endpoints from the outset.
          azure_relay_namespace                = true
          azure_search_service                 = true
          azure_service_bus_namespace          = true
          azure_site_recovery                  = true
          azure_sql_database_sqlserver         = true
          azure_synapse_analytics_dev          = false //Interferes with Synapse Studio Portal (https://web.azuresynapse.net/en/) for Azure Synapse Workspaces not using private endpoints.
          azure_synapse_analytics_sql          = false //Interferes with Synapse Studio Portal (https://web.azuresynapse.net/en/) for Azure Synapse Workspaces not using private endpoints. Further details are available here.
          azure_synapse_studio                 = false //Interferes with Synapse Studio Portal (https://web.azuresynapse.net/en/) for Azure Synapse Workspaces not using private endpoints. Further details are available here.
          azure_web_apps_sites                 = true
          azure_web_apps_static_sites          = true
          cognitive_services_account           = true
          microsoft_power_bi                   = false //Affects Power BI and Microsoft Fabric services if not configured to use private endpoints from the outset
          signalr                              = true
          signalr_webpubsub                    = true
          storage_account_blob                 = true
          storage_account_file                 = true
          storage_account_queue                = true
          storage_account_table                = true
          storage_account_web                  = true
        }
        private_link_locations = [
          "australiaeast"
        ]
        public_dns_zones                                       = []
        private_dns_zones                                      = []
        enable_private_dns_zone_virtual_network_link_on_hubs   = true
        enable_private_dns_zone_virtual_network_link_on_spokes = true
        virtual_network_resource_ids_to_link                   = []
      }
    }
  }

  location = "australiaeast"
  tags = {
    applicationName    = "Platform Identity"
    contactEmail       = "test@test.com"
    costCenter         = ""
    criticality        = "Tier0"
    dataClassification = "Internal"
    owner              = "Core Infrastructure"
    environment        = "Production"
  }
  advanced = {
    resource_prefix = "plat-conn"
    custom_azure_backup_geo_codes = {
      australiaeast      = "syd"
      australiasoutheast = "mel"
    }
  }
}

# Consolidated management resources: LAW + solutions only (no spoke VNet, no action group)
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
    spoke_networks       = []
    action_group_name      = "ag-plat-conn-alerts"
    action_group_shortname = "platconn"
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
    resource_prefix = "plat-conn"
    custom_azure_backup_geo_codes = {
      australiaeast      = "syd"
      australiasoutheast = "mel"
    }
  }
}

# Consolidated identity resources: Key Vault only (no spoke VNet, no VMs)
configure_identity_resources = {
  settings = {
    identity = {
      enabled = true
      config = {
        key_vault = {
          purge_protection_enabled = true
        }
      }
    }
    spoke_networks = []
  }
  location = "australiaeast"
  tags = {
    applicationName    = "Platform Identity"
    contactEmail       = "test@test.com"
    costCenter         = ""
    criticality        = "Tier0"
    dataClassification = "Internal"
    owner              = "Core Infrastructure"
    environment        = "Production"
  }
  advanced = {
    resource_prefix = "plat-conn"
    custom_azure_backup_geo_codes = {
      australiaeast      = "syd"
      australiasoutheast = "mel"
    }
    custom_settings_by_resource_type = {
      azurerm_key_vault = {
        identity = {
          name = "akv-org-syd-plat-idam-02"
        }
      }
    }
  }
}

# -----------------------------------------------------------------------------
# VPN Sites — remote endpoints outside CAF module scope
# -----------------------------------------------------------------------------
vpn_sites = {
  wcq_hq = {
    enabled       = false # Enable when VPN Gateway is deployed and HQ details confirmed
    name          = "vpnsite-wcq-hq-01"
    location      = "australiaeast"
    device_vendor = "" # e.g. "Cisco", "Fortinet", "Palo Alto"
    device_model  = ""
    address_cidrs = [] # e.g. ["192.168.0.0/16"] — HQ on-prem address space
    link = [
      {
        name          = "link-wcq-hq-primary"
        ip_address    = "0.0.0.0" # Replace with actual HQ public IP
        speed_in_mbps = 100
        bgp           = [] # Add BGP config if using dynamic routing
      }
    ]
    tags = {
      environment = "Production"
      purpose     = "S2S VPN to WCQ Head Office"
    }
  }
}

# -----------------------------------------------------------------------------
# VPN Connections — S2S tunnels outside CAF module scope
# -----------------------------------------------------------------------------
vpn_connections = {
  wcq_hq = {
    enabled       = false # Enable when VPN site is deployed and PSK is agreed
    name          = "vpnconn-wcq-hq-01"
    vpn_site_key  = "wcq_hq"
    internet_security_enabled = true # Route internet traffic through Firewall via Routing Intent
    vpn_link = [
      {
        name                = "link-wcq-hq-primary"
        vpn_site_link_index = 0
        bandwidth_mbps      = 100
        protocol            = "IKEv2"
        shared_key          = "" # Set via Key Vault or pipeline secret — never hardcode
        bgp_enabled         = false
        ipsec_policy = [
          {
            sa_lifetime_sec  = 27000
            sa_data_size_kb  = 102400000
            ipsec_encryption = "AES256"
            ipsec_integrity  = "SHA256"
            ike_encryption   = "AES256"
            ike_integrity    = "SHA256"
            dh_group         = "DHGroup14"
            pfs_group        = "PFS14"
          }
        ]
      }
    ]
  }
}
