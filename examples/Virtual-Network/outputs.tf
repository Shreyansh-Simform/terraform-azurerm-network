# Resource Group Outputs
output "resource_group_name" {
  description = "The name of the resource group"
  value       = azurerm_resource_group.resource_group.name
}

output "resource_group_id" {
  description = "The ID of the resource group"
  value       = azurerm_resource_group.resource_group.id
}

# Virtual Network Outputs
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = module.complete_network.virtual_network_name
}

output "virtual_network_id" {
  description = "The ID of the virtual network"
  value       = module.complete_network.virtual_network_id
}

output "virtual_network_address_space" {
  description = "The address space of the virtual network"
  value       = module.complete_network.virtual_network_address_space
}

# DDoS Protection Outputs
output "ddos_protection_plan_id" {
  description = "The ID of the DDoS protection plan"
  value       = module.complete_network.ddos_protection_plan_id
}

output "ddos_protection_enabled" {
  description = "Whether DDoS protection is enabled"
  value       = module.complete_network.ddos_protection_enabled
}

# Azure Bastion Outputs
output "bastion_host_id" {
  description = "The ID of the Azure Bastion host"
  value       = module.complete_network.bastion_host_id
}

output "bastion_host_fqdn" {
  description = "The FQDN of the Azure Bastion host"
  value       = module.complete_network.bastion_host_fqdn
}

output "bastion_public_ip_address" {
  description = "The public IP address of the Azure Bastion"
  value       = module.complete_network.bastion_public_ip_address
}

output "bastion_subnet_id" {
  description = "The ID of the Azure Bastion subnet"
  value       = module.complete_network.bastion_subnet_id
}

# Azure Firewall Outputs
output "firewall_id" {
  description = "The ID of the Azure Firewall"
  value       = module.complete_network.firewall_id
}

output "firewall_public_ip_address" {
  description = "The public IP address of the Azure Firewall"
  value       = module.complete_network.firewall_public_ip_address
}

output "firewall_management_ip_address" {
  description = "The management public IP address of the Azure Firewall"
  value       = module.complete_network.firewall_management_ip_address
}

output "firewall_subnet_id" {
  description = "The ID of the Azure Firewall subnet"
  value       = module.complete_network.firewall_subnet_id
}

output "firewall_management_subnet_id" {
  description = "The ID of the Azure Firewall management subnet"
  value       = module.complete_network.firewall_management_subnet_id
}

