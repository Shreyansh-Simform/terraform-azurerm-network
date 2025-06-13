# Virtual Network Outputs
output "virtual_network_name" {
  description = "The name of the virtual network"
  value       = azurerm_virtual_network.myvnet.name
}

output "virtual_network_id" {
  description = "The ID of the virtual network"
  value       = azurerm_virtual_network.myvnet.id
}

output "virtual_network_address_space" {
  description = "The address space of the virtual network"
  value       = azurerm_virtual_network.myvnet.address_space
}

# DDoS Protection Outputs
output "ddos_protection_plan_id" {
  description = "The ID of the DDoS protection plan (if created)"
  value       = var.enable_ddos_protection && var.ddos_protection_plan_id == null ? azurerm_ddos_protection_plan.myddosplan["main"].id : null
}

output "ddos_protection_enabled" {
  description = "Whether DDoS protection is enabled on the virtual network"
  value       = var.enable_ddos_protection
}

# Bastion Outputs
output "bastion_host_id" {
  description = "The ID of the Azure Bastion host"
  value       = var.enable_azure_bastion ? azurerm_bastion_host.bastion["main"].id : null
}

output "bastion_host_fqdn" {
  description = "The FQDN of the Azure Bastion host"
  value       = var.enable_azure_bastion ? azurerm_bastion_host.bastion["main"].dns_name : null
}

output "bastion_public_ip_id" {
  description = "The ID of the Azure Bastion public IP"
  value       = var.enable_azure_bastion ? azurerm_public_ip.bastion_pip["main"].id : null
}

output "bastion_public_ip_address" {
  description = "The public IP address of the Azure Bastion"
  value       = var.enable_azure_bastion ? azurerm_public_ip.bastion_pip["main"].ip_address : null
}

output "bastion_subnet_id" {
  description = "The ID of the Azure Bastion subnet"
  value       = var.enable_azure_bastion ? azurerm_subnet.bastion_subnet["main"].id : null
}

# Firewall Outputs
output "firewall_id" {
  description = "The ID of the Azure Firewall"
  value       = var.enable_azure_firewall ? azurerm_firewall.firewall["main"].id : null
}

output "firewall_public_ip_id" {
  description = "The ID of the Azure Firewall public IP"
  value       = var.enable_azure_firewall ? azurerm_public_ip.firewall_pip["main"].id : null
}

output "firewall_public_ip_address" {
  description = "The public IP address of the Azure Firewall"
  value       = var.enable_azure_firewall ? azurerm_public_ip.firewall_pip["main"].ip_address : null
}

output "firewall_management_ip_id" {
  description = "The ID of the Azure Firewall management public IP"
  value       = var.enable_azure_firewall ? azurerm_public_ip.firewall_management_pip["main"].id : null
}

output "firewall_management_ip_address" {
  description = "The management public IP address of the Azure Firewall"
  value       = var.enable_azure_firewall ? azurerm_public_ip.firewall_management_pip["main"].ip_address : null
}

output "firewall_subnet_id" {
  description = "The ID of the Azure Firewall subnet"
  value       = var.enable_azure_firewall ? azurerm_subnet.firewall_subnet["main"].id : null
}

output "firewall_management_subnet_id" {
  description = "The ID of the Azure Firewall management subnet"
  value       = var.enable_azure_firewall ? azurerm_subnet.management_subnet["main"].id : null
}

# Subnet Outputs
output "subnet_ids" {
  description = "Map of subnet names to their IDs"
  value       = { for k, v in azurerm_subnet.mysubnet : k => v.id }
}

output "subnet_names" {
  description = "List of subnet names"
  value       = keys(azurerm_subnet.mysubnet)
}

output "subnet_address_prefixes" {
  description = "Map of subnet names to their address prefixes"
  value       = { for k, v in azurerm_subnet.mysubnet : k => v.address_prefixes }
}

output "subnets_details" {
  description = "Complete subnet information including name, id, and address prefixes"
  value = {
    for k, v in azurerm_subnet.mysubnet : k => {
      id               = v.id
      name             = v.name
      address_prefixes = v.address_prefixes
      service_endpoints = v.service_endpoints
      private_endpoint_network_policies = v.private_endpoint_network_policies
    }
  }
}

# Route Table Outputs
output "route_table_ids" {
  description = "Map of route table names to their IDs"
  value       = { for k, v in azurerm_route_table.network-route-table : k => v.id }
}

output "route_table_names" {
  description = "List of route table names"
  value       = keys(azurerm_route_table.network-route-table)
}

output "route_tables_details" {
  description = "Complete route table information"
  value = {
    for k, v in azurerm_route_table.network-route-table : k => {
      id                            = v.id
      name                          = v.name
      bgp_route_propagation_enabled = v.bgp_route_propagation_enabled
      routes                        = v.route
    }
  }
}

# Route Table Association Outputs
output "route_table_associations" {
  description = "Map of subnet names to their associated route table IDs"
  value = {
    for k, v in azurerm_subnet_route_table_association.route_table_associations : k => {
      subnet_id      = v.subnet_id
      route_table_id = v.route_table_id
    }
  }
}

# Network Security Group Outputs
output "network_security_group_ids" {
  description = "Map of NSG names to their IDs"
  value       = { for k, v in azurerm_network_security_group.network-nsg : k => v.id }
}

output "network_security_group_names" {
  description = "List of NSG names"
  value       = keys(azurerm_network_security_group.network-nsg)
}

output "nsg_subnet_associations" {
  description = "Map of subnet names to their associated NSG IDs"
  value = {
    for k, v in azurerm_subnet_network_security_group_association.nsg_associations : k => {
      subnet_id = v.subnet_id
      nsg_id    = v.network_security_group_id
    }
  }
}

# Public IP Outputs
output "public_ip_ids" {
  description = "Map of public IP names to their IDs"
  value       = { for k, v in azurerm_public_ip.my-pubip : k => v.id }
}

output "public_ip_addresses" {
  description = "Map of public IP names to their IP addresses"
  value       = { for k, v in azurerm_public_ip.my-pubip : k => v.ip_address }
}

output "public_ip_details" {
  description = "Complete public IP information"
  value = {
    for k, v in azurerm_public_ip.my-pubip : k => {
      id                = v.id
      name              = v.name
      ip_address        = v.ip_address
      allocation_method = v.allocation_method
      sku               = v.sku
    }
  }
}

# Network Interface Outputs
output "network_interface_ids" {
  description = "Map of network interface names to their IDs"
  value       = { for k, v in azurerm_network_interface.mynic : k => v.id }
}

output "network_interface_private_ips" {
  description = "Map of network interface names to their private IP addresses"
  value       = { for k, v in azurerm_network_interface.mynic : k => v.private_ip_address }
}

output "network_interfaces_details" {
  description = "Complete network interface information"
  value = {
    for k, v in azurerm_network_interface.mynic : k => {
      id                    = v.id
      name                  = v.name
      private_ip_address    = v.private_ip_address
      subnet_id            = v.ip_configuration[0].subnet_id
      public_ip_address_id = v.ip_configuration[0].public_ip_address_id
    }
  }
}

# Summary Outputs
output "network_summary" {
  description = "Summary of the entire network configuration"
  value = {
    virtual_network = {
      name          = azurerm_virtual_network.myvnet.name
      id            = azurerm_virtual_network.myvnet.id
      address_space = azurerm_virtual_network.myvnet.address_space
    }
    security_features = {
      ddos_protection_enabled = var.enable_ddos_protection
      bastion_enabled        = var.enable_azure_bastion
      firewall_enabled       = var.enable_azure_firewall
    }
    counts = {
      subnets               = length(azurerm_subnet.mysubnet)
      route_tables         = length(azurerm_route_table.network-route-table)
      network_security_groups = length(azurerm_network_security_group.network-nsg)
      public_ips           = length(azurerm_public_ip.my-pubip)
      network_interfaces   = length(azurerm_network_interface.mynic)
      route_table_associations = length(azurerm_subnet_route_table_association.route_table_associations)
      nsg_subnet_associations = length(azurerm_subnet_network_security_group_association.nsg_associations)
    }
  }
}