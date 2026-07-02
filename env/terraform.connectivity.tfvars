
deploy_core_landing_zones   = false
deploy_corp_landing_zones   = false
deploy_online_landing_zones = false

deploy_connectivity_resources = true
deploy_identity_resources     = false
deploy_management_resources   = false
deploy_landingzones_resources = false

# Configure the connectivity resources settings.
configure_connectivity_resources = {
  settings = {
    hub_networks = [
      {
        enabled = true
        config = {
          address_space                = ["10.100.0.0/16", ]
          location                     = "australiaeast"
          link_to_ddos_protection_plan = false
          dns_servers                  = []
          bgp_community                = ""
          subnets                      = []
          virtual_network_gateway = {
            enabled = true
            config = {
              address_prefix           = "10.100.1.0/24"
              gateway_sku_expressroute = "ErGw2AZ"
              gateway_sku_vpn          = ""
              advanced_vpn_settings = {
                enable_bgp                       = null
                active_active                    = null
                private_ip_address_allocation    = ""
                default_local_network_gateway_id = ""
                vpn_client_configuration         = []
                bgp_settings                     = []
                custom_route                     = []
              }
            }
          }
          azure_firewall = {
            enabled = true
            config = {
              address_prefix                = "10.100.0.0/24"
              enable_dns_proxy              = true
              dns_servers                   = []
              sku_tier                      = ""
              base_policy_id                = ""
              private_ip_ranges             = []
              threat_intelligence_mode      = ""
              threat_intelligence_allowlist = []
              availability_zones = {
                zone_1 = true
                zone_2 = true
                zone_3 = true
              }
            }
          }
          bastion = {
            enabled = true
            config = {
              address_prefix     = "10.100.2.0/24"
              sku                = "Standard" // Basic, Standard, or Premium
              ip_connect_enabled = true
              tunneling_enabled  = true
              availability_zones = {
                zone_1 = true
                zone_2 = true
                zone_3 = true
              }
            }
          }
          spoke_virtual_network_resource_ids = [
            # "spoke_resource_id_1",

          ]
          enable_outbound_virtual_network_peering = true
          enable_hub_network_mesh_peering         = false
        }
      }
    ]
    vwan_hub_networks = []
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
