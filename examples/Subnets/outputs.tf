# Resource Group Outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.resource_group.id
}

# Subnet Outputs
output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = module.complete_network.subnet_ids
}

output "subnet_names" {
  description = "List of all subnet names"
  value       = module.complete_network.subnet_names
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to their address prefixes"
  value       = module.complete_network.subnet_address_prefixes
}

output "subnets_details" {
  description = "Complete subnet information including name, id, address prefixes, and service endpoints"
  value       = module.complete_network.subnets_details
}

# Tier-specific Subnet Outputs
output "web_tier_subnet_id" {
  description = "The ID of the web tier subnet"
  value       = module.complete_network.subnet_ids["web-tier-subnet"]
}

output "app_tier_subnet_id" {
  description = "The ID of the application tier subnet"
  value       = module.complete_network.subnet_ids["app-tier-subnet"]
}

output "db_tier_subnet_id" {
  description = "The ID of the database tier subnet"
  value       = module.complete_network.subnet_ids["db-tier-subnet"]
}

output "dmz_subnet_id" {
  description = "The ID of the DMZ subnet"
  value       = module.complete_network.subnet_ids["dmz-subnet"]
}

output "management_subnet_id" {
  description = "The ID of the management subnet"
  value       = module.complete_network.subnet_ids["management-subnet"]
}

# Specialized Subnet Outputs
output "sql_mi_subnet_id" {
  description = "The ID of the SQL Managed Instance subnet"
  value       = module.complete_network.subnet_ids["sql-mi-subnet"]
}

output "app_service_subnet_id" {
  description = "The ID of the App Service subnet"
  value       = module.complete_network.subnet_ids["app-service-subnet"]
}

output "private_endpoints_subnet_id" {
  description = "The ID of the Private Endpoints subnet"
  value       = module.complete_network.subnet_ids["private-endpoints-subnet"]
}

# Network Security Group Outputs
output "network_security_group_ids" {
  description = "Map of NSG names to their IDs"
  value       = module.complete_network.network_security_group_ids
}

output "nsg_subnet_associations" {
  description = "Map of subnet names to their associated NSG IDs"
  value       = module.complete_network.nsg_subnet_associations
}

# Route Table Outputs
output "route_table_ids" {
  description = "Map of route table names to their IDs"
  value       = module.complete_network.route_table_ids
}

output "route_table_associations" {
  description = "Map of subnet names to their associated route table IDs"
  value       = module.complete_network.route_table_associations
}