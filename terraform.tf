# Configure the minimum required providers supported by this module
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.54.0"
      configuration_aliases = [
        azurerm.connectivity,
        azurerm.management,
        azurerm.identity,
        azurerm.landingzones,
        azurerm.security,
      ]
    }
    time = {
      source  = "hashicorp/time"
      version = ">= 0.7.0"
    }
    azapi = {
      source  = "Azure/azapi"
      version = ">= 1.3.0"
    }
  }

  required_version = ">= 1.3.1"

  backend "azurerm" {
  resource_group_name  = "rg-tfstate-caf-test-aue-001"
  storage_account_name = "stcafterraformtest001"
  container_name       = "tfstate"
  key                  = "caf-enterprise-scale.tfstate"
  subscription_id      = "1336f5fd-b39b-4d15-aa73-7e1ed659b9c1"
  }
}

provider "azurerm" {
  resource_provider_registrations = "none"
  features {}
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = local.subscription_id_connectivity
  features {}
  alias = "connectivity"
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = local.subscription_id_management
  features {}
  alias = "management"
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = local.subscription_id_identity
  features {
    key_vault {
      recover_soft_deleted_key_vaults = false
    }
  }
  alias = "identity"
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = local.subscription_id_landingzones
  features {}
  alias = "landingzones"
}

provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id                 = local.subscription_id_security
  features {}
  alias = "security"
}
