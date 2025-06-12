# Complete Network Module Example
# This example demonstrates all features and resources available in the Network module

# First, create a resource group (you can use the Resource-Group module or create manually)
module "resource_group" {
  source = ".."
  
  rg_name     = "complete-network-rg"
  rg_location = "East US"
}

# Complete Network Module with All Features
module "complete_network" {
  source = ".."  # Path to the Network module

  # Basic Configuration - Required Variables
  rg_name              = module.resource_group.rg_name
  rg_location          = module.resource_group.rg_location
  virtual_network_name = "enterprise-vnet"
  address_space        = ["10.0.0.0/16"]
  dns_servers          = ["168.63.129.16", "8.8.8.8"]  # Azure DNS + Google DNS

  # Security Features - All Enabled
  enable_ddos_protection = true
  enable_azure_bastion   = true
  enable_azure_firewall  = true

  # Azure Bastion Configuration
  azure_bastion_name        = "enterprise-bastion"
  bastion_subnet_prefix     = "10.0.100.0/27"  # /27 minimum for Bastion
  bastion_sku              = "Standard"
  bastion_scale_units      = 3
  bastion_availability_zones = ["1", "2", "3"]

  # Azure Firewall Configuration
  firewall_name               = "enterprise-firewall"
  firewall_subnet_address     = "10.0.200.0/26"  # /26 minimum for Firewall
  management_subnet_address   = "10.0.201.0/26"  # /26 minimum for Management
  firewall_sku               = "Premium"
  firewall_sku_name          = "AZFW_VNet"

}

