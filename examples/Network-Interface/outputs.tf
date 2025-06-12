# Resource Group Outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.resource_group.id
}

# Network Interface Outputs
output "network_interface_ids" {
  description = "Map of network interface names to their IDs"
  value       = module.complete_network.network_interface_ids
}

output "network_interface_private_ips" {
  description = "Map of network interface names to their private IP addresses"
  value       = module.complete_network.network_interface_private_ips
}

output "network_interfaces_details" {
  description = "Complete network interface information including private IPs, subnet IDs, and public IP associations"
  value       = module.complete_network.network_interfaces_details
}

# Web Tier Network Interface Outputs
output "web_server_nic_01_id" {
  description = "The ID of the first web server network interface"
  value       = module.complete_network.network_interface_ids["web-server-nic-01"]
}

output "web_server_nic_01_private_ip" {
  description = "The private IP address of the first web server network interface"
  value       = module.complete_network.network_interface_private_ips["web-server-nic-01"]
}

output "web_server_nic_02_id" {
  description = "The ID of the second web server network interface"
  value       = module.complete_network.network_interface_ids["web-server-nic-02"]
}

output "web_server_nic_02_private_ip" {
  description = "The private IP address of the second web server network interface"
  value       = module.complete_network.network_interface_private_ips["web-server-nic-02"]
}

# App Tier Network Interface Outputs
output "app_server_nic_01_id" {
  description = "The ID of the first app server network interface"
  value       = module.complete_network.network_interface_ids["app-server-nic-01"]
}

output "app_server_nic_01_private_ip" {
  description = "The private IP address of the first app server network interface"
  value       = module.complete_network.network_interface_private_ips["app-server-nic-01"]
}

output "app_server_nic_02_id" {
  description = "The ID of the second app server network interface"
  value       = module.complete_network.network_interface_ids["app-server-nic-02"]
}

output "app_server_nic_02_private_ip" {
  description = "The private IP address of the second app server network interface"
  value       = module.complete_network.network_interface_private_ips["app-server-nic-02"]
}

# Database Tier Network Interface Outputs
output "db_server_nic_01_id" {
  description = "The ID of the database server network interface"
  value       = module.complete_network.network_interface_ids["db-server-nic-01"]
}

output "db_server_nic_01_private_ip" {
  description = "The private IP address of the database server network interface"
  value       = module.complete_network.network_interface_private_ips["db-server-nic-01"]
}

# Load Balancer Network Interface Outputs
output "load_balancer_nic_id" {
  description = "The ID of the load balancer network interface"
  value       = module.complete_network.network_interface_ids["lb-nic"]
}

output "load_balancer_nic_private_ip" {
  description = "The private IP address of the load balancer network interface"
  value       = module.complete_network.network_interface_private_ips["lb-nic"]
}

# Management VM Network Interface Outputs
output "management_vm_nic_id" {
  description = "The ID of the management VM network interface"
  value       = module.complete_network.network_interface_ids["mgmt-vm-nic"]
}

output "management_vm_nic_private_ip" {
  description = "The private IP address of the management VM network interface"
  value       = module.complete_network.network_interface_private_ips["mgmt-vm-nic"]
}

# Application Gateway Network Interface Outputs
output "application_gateway_nic_id" {
  description = "The ID of the application gateway network interface"
  value       = module.complete_network.network_interface_ids["appgw-nic"]
}

output "application_gateway_nic_private_ip" {
  description = "The private IP address of the application gateway network interface"
  value       = module.complete_network.network_interface_private_ips["appgw-nic"]
}