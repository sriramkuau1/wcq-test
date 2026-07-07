# ============================================================================
# Landing Zone Template
# ============================================================================
# Copy this file to: env/terraform.<name>.lz.tfvars
# Example: env/terraform.corp-web.lz.tfvars
#
# Before deploying:
#   1. Create the Terraform workspace: terraform workspace new <name>
#   2. Replace all <PLACEHOLDER> values below
#   3. Assign a non-overlapping address space from your IPAM
#   4. Tighten NSG rules for your workload's traffic requirements
#   5. Set the hub_network_id to your connectivity hub VNet resource ID
#   6. Trigger the workflow:
#        Workflow: Deploy Landing Zones
#        Inputs:   landingzone=<name>, subscriptionId=<sub-id>, deploy=true
# ============================================================================

deploy_core_landing_zones   = false
deploy_corp_landing_zones   = false
deploy_online_landing_zones = false

deploy_connectivity_resources = false
deploy_identity_resources     = false
deploy_management_resources   = false
deploy_landingzones_resources = true

# Not used at runtime — the workflow passes subscription ID via ARM_SUBSCRIPTION_ID.
# Kept for documentation only.
subscription_id_landingzones = ""

configure_landingzones_resources = {
  settings = {
    # -- Budget and cost alerting --
    landingzones = {
      enabled = true
      config = {
        amount                 = 500                        # Monthly budget in AUD/USD
        start_date             = "<YYYY-MM-01T00:00:00Z>"   # Budget start (first of month)
        end_date               = "<YYYY-MM-01T00:00:00Z>"   # Budget end
        subscription_name      = "sub-lz-<archetype>-<workload>-01"
        action_group_name      = "<WORKLOAD>-Action-Group"
        action_group_shortname = "<WL>-AG"                  # Max 12 chars
        enable_notifications   = true
        threshold              = "80.0"                     # Alert at 80% spend
        operator               = "GreaterThan"
        contact_email          = "<team-dl@contoso.com>"
      }
    }

    # -- RBAC assignments --
    # Add one block per role. Use built-in role definition IDs.
    # Common roles:
    #   Contributor:           b24988ac-6180-42a0-ab88-20f7382dd24c
    #   Reader:                acdd72a7-3385-48ef-bd42-f606fba81ae7
    #   Network Contributor:   4d97b98b-1d4f-4787-a291-c67834d212e7
    rbac = [
      # {
      #   role_definition_id = "/subscriptions/<SUB_ID>/providers/Microsoft.Authorization/roleDefinitions/<ROLE_GUID>"
      #   principal_id       = "<ENTRA_GROUP_OR_USER_OBJECT_ID>"
      # },
    ]

    # -- Spoke network --
    spoke_networks = [
      {
        identifier = "vnet_australiaeast"
        enabled    = true
        config = {
          address_space                = ["<10.X.X.0/24>"]  # Non-overlapping CIDR from IPAM
          location                     = "australiaeast"
          link_to_ddos_protection_plan = false
          dns_servers                  = []                  # Empty = Azure-provided DNS
          subnets = [
            {
              name                          = "workload"
              address_prefixes              = ["<10.X.X.0/25>"]
              bgp_route_propagation_enabled = false
              routes                        = []
              # TODO: Replace Allow-All rules with workload-specific ingress/egress
              rules = [
                {
                  name                       = "AllowVNetInbound"
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
                  name                       = "DenyAllInbound"
                  priority                   = 4096
                  direction                  = "Inbound"
                  access                     = "Deny"
                  protocol                   = "*"
                  source_port_range          = "*"
                  destination_port_range     = "*"
                  source_address_prefix      = "*"
                  destination_address_prefix = "*"
                },
                {
                  name                       = "AllowVNetOutbound"
                  priority                   = 100
                  direction                  = "Outbound"
                  access                     = "Allow"
                  protocol                   = "*"
                  source_port_range          = "*"
                  destination_port_range     = "*"
                  source_address_prefix      = "VirtualNetwork"
                  destination_address_prefix = "VirtualNetwork"
                },
                {
                  name                       = "DenyAllOutbound"
                  priority                   = 4096
                  direction                  = "Outbound"
                  access                     = "Deny"
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
              address_prefixes              = ["<10.X.X.128/25>"]
              bgp_route_propagation_enabled = false
              routes                        = []
              rules = [
                {
                  name                       = "AllowVNetInbound"
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
                  name                       = "DenyAllInbound"
                  priority                   = 4096
                  direction                  = "Inbound"
                  access                     = "Deny"
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

          # Hub VNet resource ID for peering — get from connectivity deployment output
          hub_network_id               = "/subscriptions/<SUB_ID>/resourceGroups/rg-syd-plat-conn-connectivity/providers/Microsoft.Network/virtualNetworks/vnt-syd-plat-conn-10.100.0.0_16"
          allow_virtual_network_access = true
          allow_forwarded_traffic      = true
          use_remote_gateways          = false
        }
      }
    ]
  }

  location = "australiaeast"
  tags = {
    applicationName    = "<Application Name>"
    contactEmail       = "<team-dl@contoso.com>"
    costCenter         = "<CC-XXXX>"
    criticality        = "Tier1"                # Tier0 = platform, Tier1 = prod, Tier2 = non-prod
    dataClassification = "Internal"             # Internal | Confidential | Public
    owner              = "<Team Name>"
    environment        = "Production"           # Production | Staging | Development
  }
  advanced = {
    resource_prefix = "lz-<workload>"           # Short prefix for resource naming
    custom_azure_backup_geo_codes = {
      australiaeast      = "syd"
      australiasoutheast = "mel"
    }
  }
}
