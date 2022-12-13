
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.15.1"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "rg-coretekgov-mgmt-usva-001"
  #   storage_account_name = "sthubstatetransitusva001"
  #   container_name       = "tfstate"
  #   key                  = "terraform.tfstate"
  # }
}

provider "azurerm" {
  features {

  }
}