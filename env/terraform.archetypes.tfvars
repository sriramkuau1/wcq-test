
# Disable core MGs — custom hierarchy defined in custom_landing_zones below
deploy_core_landing_zones   = false
deploy_corp_landing_zones   = false
deploy_online_landing_zones = false

deploy_connectivity_resources = false
deploy_identity_resources     = false
deploy_management_resources   = false
deploy_landingzones_resources = false

# Not needed when using custom_landing_zones with default_empty archetypes
archetype_config_overrides = {}

# Custom MG hierarchy: MG structure only, no governance artifacts
custom_landing_zones = {
  # Level 1: Root
  wcq = {
    display_name               = "WCQ"
    parent_management_group_id = "6c637512-c417-4e78-9d62-b61258e4b619"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # Level 2: Platform
  wcq-platform = {
    display_name               = "Platform"
    parent_management_group_id = "wcq"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # Level 2: Workloads
  wcq-workloads = {
    display_name               = "Workloads"
    parent_management_group_id = "wcq"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # Level 2: Sandbox
  wcq-sandbox = {
    display_name               = "Sandbox"
    parent_management_group_id = "wcq"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # Level 2: Decommissioned
  wcq-decommissioned = {
    display_name               = "Decommissioned"
    parent_management_group_id = "wcq"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # Level 3: Platform children
  wcq-connectivity = {
    display_name               = "Connectivity"
    parent_management_group_id = "wcq-platform"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  wcq-management = {
    display_name               = "Management"
    parent_management_group_id = "wcq-platform"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  wcq-identity = {
    display_name               = "Identity"
    parent_management_group_id = "wcq-platform"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  wcq-security = {
    display_name               = "Security"
    parent_management_group_id = "wcq-platform"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # Level 3: Workload children
  wcq-internal = {
    display_name               = "Internal"
    parent_management_group_id = "wcq-workloads"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  wcq-online = {
    display_name               = "Online"
    parent_management_group_id = "wcq-workloads"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # ─── EPAC Policy Testing Hierarchy ───────────────────────────────────
  # Separate MG tree for EPAC policy development, validation and testing.
  # Mirrors the WCQ structure but rooted directly under Tenant Root Group.

  # Level 1: EPAC Root
  epac-wcq = {
    display_name               = "EPAC WCQ"
    parent_management_group_id = "6c637512-c417-4e78-9d62-b61258e4b619"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # Level 2: EPAC Platform
  epac-wcq-platform = {
    display_name               = "EPAC Platform"
    parent_management_group_id = "epac-wcq"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # Level 2: EPAC Workloads
  epac-wcq-workloads = {
    display_name               = "EPAC Workloads"
    parent_management_group_id = "epac-wcq"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # Level 2: EPAC Sandbox
  epac-wcq-sandbox = {
    display_name               = "EPAC Sandbox"
    parent_management_group_id = "epac-wcq"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # Level 2: EPAC Decommissioned
  epac-wcq-decommissioned = {
    display_name               = "EPAC Decommissioned"
    parent_management_group_id = "epac-wcq"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # Level 3: EPAC Platform children
  epac-wcq-connectivity = {
    display_name               = "EPAC Connectivity"
    parent_management_group_id = "epac-wcq-platform"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  epac-wcq-management = {
    display_name               = "EPAC Management"
    parent_management_group_id = "epac-wcq-platform"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  epac-wcq-identity = {
    display_name               = "EPAC Identity"
    parent_management_group_id = "epac-wcq-platform"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  epac-wcq-security = {
    display_name               = "EPAC Security"
    parent_management_group_id = "epac-wcq-platform"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  # Level 3: EPAC Workload children
  epac-wcq-internal = {
    display_name               = "EPAC Internal"
    parent_management_group_id = "epac-wcq-workloads"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
      parameters     = {}
      access_control = {}
    }
  }

  epac-wcq-online = {
    display_name               = "EPAC Online"
    parent_management_group_id = "epac-wcq-workloads"
    subscription_ids           = []
    archetype_config = {
      archetype_id   = "default_empty"
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
