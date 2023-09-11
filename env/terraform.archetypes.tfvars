
deploy_core_landing_zones   = true
deploy_corp_landing_zones   = true
deploy_online_landing_zones = true

deploy_connectivity_resources = false
deploy_identity_resources     = false
deploy_management_resources   = false
deploy_landingzones_resources = false

subscription_id_overrides = {
  landingzones-corp = [
    ""
  ]
}
archetype_config_overrides = {
  root = {
    access_control = {
      Contributor = [
        ""
      ]
    }
  }
  landingzones = {
    parameters = {
      Deploy-VM-Backup = {
        effect            = "deployIfNotExists"
        exclusionTagName  = "SkipAutoShutdown"
        exclusionTagValue = ["yes","no"]
      }
      Append-UDR-Route = {
        nextHopIpAddress = "10.100.0.4"
      }
    }
    enforcement_mode = {}
  }
  landingzones-corp = {
    parameters = {
      Append-UDR-Route = {
        nextHopIpAddress = "10.100.0.4"
      }
    }
    enforcement_mode = {}
  }
  platform-identity = {
    parameters = {
      Append-UDR-Route = {
        nextHopIpAddress = "10.100.0.4"
      }
    }
    enforcement_mode = {}
  }
  platform-management = {
    parameters = {
      Append-UDR-Route = {
        nextHopIpAddress = "10.100.0.4"
      }
    }
    enforcement_mode = {}
  }
}

custom_landing_zones = {
  mg-org-default = {
    display_name               = "Default"
    parent_management_group_id = "mg-org"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "es_sandboxes"
      parameters     = {}
      access_control = {}
    }
  }
}

# Configure the management resources settings.
# The advenced settings are required to calculate the log analytics resource id
configure_management_resources = {
  settings = {
    security_center = {
      enabled = true
      config = {
        email_security_contact                                = "test@test.com"
        enable_defender_for_apis                              = true
        enable_defender_for_app_services                      = true
        enable_defender_for_arm                               = true
        enable_defender_for_containers                        = true
        enable_defender_for_cosmosdbs                         = true
        enable_defender_for_cspm                              = true
        enable_defender_for_dns                               = true
        enable_defender_for_key_vault                         = true
        enable_defender_for_oss_databases                     = true
        enable_defender_for_servers                           = false
        enable_defender_for_servers_vulnerability_assessments = false
        enable_defender_for_sql_servers                       = true
        enable_defender_for_sql_server_vms                    = false
        enable_defender_for_storage                           = true
      }
    }
  }
  advanced = {
    resource_prefix = "plat-mgmt"
    custom_azure_backup_geo_codes = {
      australiaeast      = "syd"
      australiasoutheast = "mel"
    }
  }
}