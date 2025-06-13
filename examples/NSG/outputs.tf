# Resource Group Outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.resource_group.id
}

# Network Security Group Outputs
output "network_security_group_ids" {
  description = "Map of NSG names to their IDs"
  value       = module.complete_network.network_security_group_ids
}

output "network_security_group_names" {
  description = "List of all NSG names"
  value       = module.complete_network.network_security_group_names
}

output "nsg_subnet_associations" {
  description = "Map of subnet names to their associated NSG IDs"
  value       = module.complete_network.nsg_subnet_associations
}

# Tier-specific NSG Outputs
output "web_tier_nsg_id" {
  description = "The ID of the web tier NSG"
  value       = module.complete_network.network_security_group_ids["web-tier-nsg"]
}

output "app_tier_nsg_id" {
  description = "The ID of the application tier NSG"
  value       = module.complete_network.network_security_group_ids["app-tier-nsg"]
}

output "db_tier_nsg_id" {
  description = "The ID of the database tier NSG"
  value       = module.complete_network.network_security_group_ids["db-tier-nsg"]
}

output "dmz_nsg_id" {
  description = "The ID of the DMZ NSG"
  value       = module.complete_network.network_security_group_ids["dmz-nsg"]
}

output "management_nsg_id" {
  description = "The ID of the management NSG"
  value       = module.complete_network.network_security_group_ids["management-nsg"]
}

# Specialized NSG Outputs
output "sql_mi_nsg_id" {
  description = "The ID of the SQL Managed Instance NSG"
  value       = module.complete_network.network_security_group_ids["sql-mi-nsg"]
}

output "app_service_nsg_id" {
  description = "The ID of the App Service NSG"
  value       = module.complete_network.network_security_group_ids["app-service-nsg"]
}

output "private_endpoints_nsg_id" {
  description = "The ID of the Private Endpoints NSG"
  value       = module.complete_network.network_security_group_ids["private-endpoints-nsg"]
}