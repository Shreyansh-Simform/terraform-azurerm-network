terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

# Configure backend for state management (uncomment and configure as needed)
# terraform {
#   backend "azurerm" {
#     resource_group_name  = "terraform-state-rg"
#     storage_account_name = "terraformstatestorage"
#     container_name       = "tfstate"
#     key                  = "network.terraform.tfstate"
#   }
# }