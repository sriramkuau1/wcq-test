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
    resource_group_name  = ""
    storage_account_name = ""
    container_name       = ""
    key                  = "terraform.tfstate"
    subscription_id      = ""
  }
}

provider "azurerm" {
  skip_provider_registration = "true"
  features {}
}

provider "azurerm" {
  skip_provider_registration = "true"
  subscription_id = local.subscription_id_connectivity
  features {}
  alias = "connectivity"
}

provider "azurerm" {
  skip_provider_registration = "true"
  subscription_id = local.subscription_id_management
  features {}
  alias = "management"
}

provider "azurerm" {
  skip_provider_registration = "true"
  subscription_id = local.subscription_id_identity
  features {}
  alias = "identity"
}

provider "azurerm" {
  skip_provider_registration = "true"
  subscription_id = local.subscription_id_landingzones
  features {}
  alias = "landingzones"
}

provider "azurerm" {
  # skip_provider_registration = "true"
  subscription_id = local.subscription_id_security
  features {}
  alias = "security"
}
