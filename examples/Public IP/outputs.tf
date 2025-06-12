# Resource Group Outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.resource_group.id
}

# Public IP Outputs
output "public_ip_ids" {
  description = "Map of public IP names to their IDs"
  value       = module.complete_network.public_ip_ids
}

output "public_ip_addresses" {
  description = "Map of public IP names to their IP addresses"
  value       = module.complete_network.public_ip_addresses
}

output "public_ip_details" {
  description = "Complete public IP information including allocation method and SKU"
  value       = module.complete_network.public_ip_details
}

# Service-specific Public IP Outputs
output "load_balancer_public_ip_id" {
  description = "The ID of the Load Balancer public IP"
  value       = module.complete_network.public_ip_ids["lb-public-ip"]
}

output "load_balancer_public_ip_address" {
  description = "The IP address of the Load Balancer public IP"
  value       = module.complete_network.public_ip_addresses["lb-public-ip"]
}

output "application_gateway_public_ip_id" {
  description = "The ID of the Application Gateway public IP"
  value       = module.complete_network.public_ip_ids["appgw-public-ip"]
}

output "application_gateway_public_ip_address" {
  description = "The IP address of the Application Gateway public IP"
  value       = module.complete_network.public_ip_addresses["appgw-public-ip"]
}

output "management_vm_public_ip_id" {
  description = "The ID of the Management VM public IP"
  value       = module.complete_network.public_ip_ids["mgmt-vm-public-ip"]
}

output "management_vm_public_ip_address" {
  description = "The IP address of the Management VM public IP"
  value       = module.complete_network.public_ip_addresses["mgmt-vm-public-ip"]
}

output "nat_gateway_public_ip_id" {
  description = "The ID of the NAT Gateway public IP"
  value       = module.complete_network.public_ip_ids["nat-gateway-public-ip"]
}

output "nat_gateway_public_ip_address" {
  description = "The IP address of the NAT Gateway public IP"
  value       = module.complete_network.public_ip_addresses["nat-gateway-public-ip"]
}

output "vpn_gateway_public_ip_id" {
  description = "The ID of the VPN Gateway public IP"
  value       = module.complete_network.public_ip_ids["vpn-gateway-public-ip"]
}

output "vpn_gateway_public_ip_address" {
  description = "The IP address of the VPN Gateway public IP"
  value       = module.complete_network.public_ip_addresses["vpn-gateway-public-ip"]
}