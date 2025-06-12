# Complete Network Module Example
# This example demonstrates all features and resources available in the Network module

# First, create a resource group (you can use the Resource-Group module or create manually)
resource "azurerm_resource_group" "resource_group" {
  name     = var.ResourceGroupName
  location = var.ResourceGroupLocation
}
# Complete Network Module with All Features
module "complete_network" {
  source = ".."  # Path to the Network module

  # Basic Configuration - Required Variables
  rg_name              = azurerm_resource_group.resource_group.name
  rg_location          = azurerm_resource_group.resource_group.location
  virtual_network_name = var.virtual_network_name
  address_space        = var.address_space
  dns_servers          = var.dns_servers # Azure DNS + Google DNS

  # Security Features - All Enabled
  enable_ddos_protection = true
  enable_azure_bastion   = true
  enable_azure_firewall  = true

  # Azure Bastion Configuration
  azure_bastion_name        = var.bastion_name
  bastion_subnet_prefix     = var.azure_bastion_subnet_prefix   # /27 minimum for Bastion
  bastion_sku              = var.azure_bastion_sku # Default is Standard
  bastion_scale_units      = var.azure_bastion_scale_units
  bastion_availability_zones = var.azure_bastion_availability_zones

  # Azure Firewall Configuration
  firewall_name               = var.azure_firewall_name
  firewall_subnet_address     = var.azure_firewall_subnet_address # /26 minimum for Firewall
  management_subnet_address   = var.firewall_management_subnet_address # /26 minimum for Management
  firewall_sku               = var.azure_firewall_sku
  firewall_sku_name          = var.azure_firewall_sku_name

}

