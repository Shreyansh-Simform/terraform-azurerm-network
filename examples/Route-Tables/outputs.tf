# Resource Group Outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.resource_group.id
}

# Route Table Outputs
output "route_table_ids" {
  description = "Map of route table names to their IDs"
  value       = module.complete_network.route_table_ids
}

output "route_table_names" {
  description = "List of all route table names"
  value       = module.complete_network.route_table_names
}

output "route_tables_details" {
  description = "Complete route table information including routes and BGP settings"
  value       = module.complete_network.route_tables_details
}

# Tier-specific Route Table Outputs
output "web_tier_route_table_id" {
  description = "The ID of the web tier route table"
  value       = module.complete_network.route_table_ids["web-tier-routes"]
}

output "app_tier_route_table_id" {
  description = "The ID of the application tier route table"
  value       = module.complete_network.route_table_ids["app-tier-routes"]
}

output "db_tier_route_table_id" {
  description = "The ID of the database tier route table"
  value       = module.complete_network.route_table_ids["db-tier-routes"]
}

output "dmz_route_table_id" {
  description = "The ID of the DMZ route table"
  value       = module.complete_network.route_table_ids["dmz-routes"]
}

output "management_route_table_id" {
  description = "The ID of the management route table"
  value       = module.complete_network.route_table_ids["management-routes"]
}

output "sql_mi_route_table_id" {
  description = "The ID of the SQL Managed Instance route table"
  value       = module.complete_network.route_table_ids["sql-mi-routes"]
}
