# VPN Site and Connection resources — outside CAF module scope.
# The CAF module creates the VPN Gateway inside the vWAN hub;
# these resources define the remote site and establish the S2S tunnel.

# -----------------------------------------------------------------------------
# Variables — VPN connection parameters from tfvars
# -----------------------------------------------------------------------------

variable "vpn_sites" {
  type = map(object({
    enabled     = optional(bool, false)
    name        = string
    location    = optional(string, "australiaeast")
    device_vendor = optional(string, "")
    device_model  = optional(string, "")
    link = list(object({
      name       = string
      ip_address = string
      speed_in_mbps = optional(number, 100)
      bgp = optional(list(object({
        asn             = number
        peering_address = string
      })), [])
    }))
    address_cidrs = optional(list(string), [])
    tags          = optional(map(string), {})
  }))
  default     = {}
  description = "Map of VPN sites (remote endpoints) to create and connect to the vWAN VPN Gateway."
}

variable "vpn_connections" {
  type = map(object({
    enabled       = optional(bool, false)
    name          = string
    vpn_site_key  = string # Key into var.vpn_sites
    internet_security_enabled = optional(bool, true)
    vpn_link = list(object({
      name             = string
      vpn_site_link_index = optional(number, 0)
      bandwidth_mbps   = optional(number, 100)
      protocol         = optional(string, "IKEv2")
      shared_key       = optional(string, "") # Use empty string + Key Vault reference in practice
      bgp_enabled      = optional(bool, false)
      ipsec_policy = optional(list(object({
        sa_lifetime_sec          = optional(number, 27000)
        sa_data_size_kb          = optional(number, 102400000)
        ipsec_encryption         = optional(string, "AES256")
        ipsec_integrity          = optional(string, "SHA256")
        ike_encryption           = optional(string, "AES256")
        ike_integrity            = optional(string, "SHA256")
        dh_group                 = optional(string, "DHGroup14")
        pfs_group                = optional(string, "PFS14")
      })), [])
    }))
  }))
  default     = {}
  description = "Map of VPN gateway connections linking VPN sites to the vWAN VPN Gateway."
}

# -----------------------------------------------------------------------------
# Locals — resolve VPN gateway reference from CAF module output
# -----------------------------------------------------------------------------

locals {
  # Get the first VPN gateway created by the CAF module (if any)
  vpn_gateway_ids = {
    for k, v in azurerm_vpn_gateway.virtual_wan : k => v.id
  }
  # Flatten to a single gateway ID (vWAN hub has one VPN gateway)
  vpn_gateway_id = length(local.vpn_gateway_ids) > 0 ? values(local.vpn_gateway_ids)[0] : null

  # Resource group for VPN sites — same as vWAN RG
  vpn_gateway_rg = length(azurerm_vpn_gateway.virtual_wan) > 0 ? values(azurerm_vpn_gateway.virtual_wan)[0].resource_group_name : null

  # Build enabled VPN sites
  enabled_vpn_sites = {
    for k, v in var.vpn_sites : k => v if v.enabled
  }

  # Build enabled VPN connections
  enabled_vpn_connections = {
    for k, v in var.vpn_connections : k => v if v.enabled
  }
}

# -----------------------------------------------------------------------------
# VPN Sites — remote endpoints (e.g. WCQ head office, branch offices)
# -----------------------------------------------------------------------------

resource "azurerm_vpn_site" "this" {
  for_each = local.enabled_vpn_sites

  provider = azurerm.connectivity

  name                = each.value.name
  resource_group_name = local.vpn_gateway_rg
  location            = each.value.location
  virtual_wan_id      = length(azurerm_virtual_wan.virtual_wan) > 0 ? values(azurerm_virtual_wan.virtual_wan)[0].id : null

  device_vendor = each.value.device_vendor
  device_model  = each.value.device_model
  address_cidrs = each.value.address_cidrs
  tags          = each.value.tags

  dynamic "link" {
    for_each = each.value.link
    content {
      name       = link.value.name
      ip_address = link.value.ip_address
      speed_in_mbps = link.value.speed_in_mbps

      dynamic "bgp" {
        for_each = link.value.bgp
        content {
          asn             = bgp.value.asn
          peering_address = bgp.value.peering_address
        }
      }
    }
  }

  depends_on = [
    azurerm_virtual_wan.virtual_wan,
    azurerm_vpn_gateway.virtual_wan,
  ]
}

# -----------------------------------------------------------------------------
# VPN Gateway Connections — S2S tunnels
# -----------------------------------------------------------------------------

resource "azurerm_vpn_gateway_connection" "this" {
  for_each = local.enabled_vpn_connections

  provider = azurerm.connectivity

  name               = each.value.name
  vpn_gateway_id     = local.vpn_gateway_id
  remote_vpn_site_id = azurerm_vpn_site.this[each.value.vpn_site_key].id

  internet_security_enabled = each.value.internet_security_enabled

  dynamic "vpn_link" {
    for_each = each.value.vpn_link
    content {
      name             = vpn_link.value.name
      vpn_site_link_id = azurerm_vpn_site.this[each.value.vpn_site_key].link[vpn_link.value.vpn_site_link_index].id
      bandwidth_mbps   = vpn_link.value.bandwidth_mbps
      protocol         = vpn_link.value.protocol
      shared_key       = vpn_link.value.shared_key

      bgp_enabled = vpn_link.value.bgp_enabled

      dynamic "ipsec_policy" {
        for_each = vpn_link.value.ipsec_policy
        content {
          sa_lifetime_sec          = ipsec_policy.value.sa_lifetime_sec
          sa_data_size_kb          = ipsec_policy.value.sa_data_size_kb
          ipsec_encryption         = ipsec_policy.value.ipsec_encryption
          ipsec_integrity          = ipsec_policy.value.ipsec_integrity
          ike_encryption           = ipsec_policy.value.ike_encryption
          ike_integrity            = ipsec_policy.value.ike_integrity
          dh_group                 = ipsec_policy.value.dh_group
          pfs_group                = ipsec_policy.value.pfs_group
        }
      }
    }
  }

  depends_on = [
    azurerm_vpn_gateway.virtual_wan,
    azurerm_vpn_site.this,
  ]
}
