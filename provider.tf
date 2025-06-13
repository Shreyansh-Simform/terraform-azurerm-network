terraform {
    required_providers {
        azurerm = {
        source  = "hashicorp/azurerm"
        version = ">= 3.0"
        }
    }
    
    required_version = ">= 1.0.0"
}

//Provider block for Azurerm
provider "azurerm" {
    features {}
    subscription_id = "56cc7e91-c9c8-45c9-958a-318ee62a00d1"
}