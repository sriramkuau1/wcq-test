deploy_core_landing_zones   = false
deploy_corp_landing_zones   = false
deploy_online_landing_zones = false

deploy_connectivity_resources = false
deploy_identity_resources     = true
deploy_management_resources   = false
deploy_landingzones_resources = false

# Configure the identity resources settings.
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
    spoke_networks = [
      {
        identifier = "vnet_australiaeast"
        enabled    = true
        config = {
          address_space                = ["10.102.0.0/24", ]
          location                     = "australiaeast"
          link_to_ddos_protection_plan = false
          dns_servers                  = []
          subnets = [
            {
              name                          = "Identity"
              address_prefixes              = ["10.102.0.0/25"]
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
          hub_network_id               = "hub-vnet"
          allow_virtual_network_access = true
          allow_forwarded_traffic      = true
          use_remote_gateways          = false
        }
      }
    ]
    # ADD: Virtual machines configuration for identity servers
    virtual_machines = {
      enabled = false
      config = [
        {
          name           = ""
          size           = "Standard_D2s_v5"
          location       = "australiaeast"
          admin_username = "azureadmin"
          admin_password = ""  # Override by Pipeline secrets
          network_interface = {
            subnet_key                    = "Identity"
            private_ip_address_allocation = "Static"
            private_ip_address           = ""  # Updated to match subnet range
            tags = {
              Role = "DomainController"
            }
          }
          os_disk = {
            caching              = "ReadWrite"
            storage_account_type = "Premium_LRS"
            disk_size_gb         = 128
          }
          source_image_reference = {
            publisher = "MicrosoftWindowsServer"
            offer     = "WindowsServer"
            sku       = "2022-Datacenter"
            version   = "latest"
          }
          tags = {
            Role        = "DomainController"
            Environment = "Production"
            Backup      = "Required"
          }
        },
        {
          name           = ""
          size           = "Standard_D2s_v5"
          location       = "australiaeast"
          admin_username = "azureadmin"
          admin_password = ""  # Override by Pipeline secrets
          network_interface = {
            subnet_key                    = "Identity"
            private_ip_address_allocation = "Static"
            private_ip_address           = ""  # Updated to match subnet range
            tags = {
              Role = "DomainController"
            }
          }
          os_disk = {
            caching              = "ReadWrite"
            storage_account_type = "Premium_LRS"
            disk_size_gb         = 128
          }
          source_image_reference = {
            publisher = "MicrosoftWindowsServer"
            offer     = "WindowsServer"
            sku       = "2022-Datacenter"
            version   = "latest"
          }
          tags = {
            Role        = "DomainController"
            Environment = "Production"
            Backup      = "Required"
          }
        }
      ]
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
    resource_prefix = "plat-idam"
    custom_azure_backup_geo_codes = {
      australiaeast      = "syd"
      australiasoutheast = "mel"
    }
  }
}
