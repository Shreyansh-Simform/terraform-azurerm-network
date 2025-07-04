//Azure Virtual Network Resource
resource "azurerm_virtual_network" "myvnet" {
  name                = var.virtual_network_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  address_space       = var.address_space
  dns_servers         = length(var.dns_servers) > 0 ? var.dns_servers : null

  # Enable DDoS protection conditionally
  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_protection ? [1] : []
    content {
      id     = var.ddos_protection_plan_id != null ? var.ddos_protection_plan_id : azurerm_network_ddos_protection_plan.myddosplan["main"].id
      enable = var.enable_ddos_protection
    }
  }

  tags = var.custom_tags

  # Prevent accidental deletion of the VNet
  lifecycle {
    prevent_destroy = true  # Managed centrally via locals.tf
    ignore_changes = [
      tags["Created"],
      tags["LastModified"]
    ]
  }
}

#Azure DDoS Protection Plan Resource  
resource "azurerm_network_ddos_protection_plan" "myddosplan" {
  for_each            = var.enable_ddos_protection && var.ddos_protection_plan_id == null ? { "main" = {} } : {}
  name                = "${var.virtual_network_name}-ddos-plan"
  location            = var.rg_location
  resource_group_name = var.rg_name
  
  # Prevent accidental deletion
  lifecycle {
    prevent_destroy = true  # Managed centrally via locals.tf
  }
}

#Bastion-Based Resources

# Special subnet for Azure Bastion (must be named "AzureBastionSubnet")
resource "azurerm_subnet" "bastion_subnet" {
  for_each             = var.enable_azure_bastion ? { "main" = {} } : {}
  name                 = "AzureBastionSubnet"  # This name is required by Azure
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = [var.bastion_subnet_prefix]
  
  # Add validation and dependency management
  lifecycle {
    precondition {
      condition     = !var.enable_azure_bastion || (var.bastion_subnet_prefix != null && var.bastion_subnet_prefix != "")
      error_message = "bastion_subnet_prefix must be provided when enable_azure_bastion is true."
    }
    prevent_destroy = true  # Managed centrally via locals.tf
  }

  depends_on = [azurerm_virtual_network.myvnet]
}

# Special public IP for Azure Bastion
resource "azurerm_public_ip" "bastion_pip" {
  for_each            = var.enable_azure_bastion ? { "main" = {} } : {}
  name                = "${var.azure_bastion_name}-pip"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  zones               = var.bastion_availability_zones
  
  lifecycle {
    precondition {
      condition     = !var.enable_azure_bastion || (var.azure_bastion_name != null && var.azure_bastion_name != "")
      error_message = "azure_bastion_name must be provided when enable_azure_bastion is true."
    }
    prevent_destroy = true  # Managed centrally via locals.tf
  }
}

#Azure Bastion Host Resource
resource "azurerm_bastion_host" "bastion" {
  for_each            = var.enable_azure_bastion ? { "main" = {} } : {}
  name                = var.azure_bastion_name
  location            = var.rg_location
  resource_group_name = var.rg_name
  sku                 = var.bastion_sku
  scale_units         = var.bastion_sku == "Standard" ? var.bastion_scale_units : null
  
  ip_configuration {
    name                 = "bastion-ip-config"
    subnet_id            = azurerm_subnet.bastion_subnet["main"].id
    public_ip_address_id = azurerm_public_ip.bastion_pip["main"].id
  }
  
  tags = var.custom_tags
  
  lifecycle {
    precondition {
      condition     = !var.enable_azure_bastion || (var.azure_bastion_name != null && var.azure_bastion_name != "")
      error_message = "azure_bastion_name must be provided when enable_azure_bastion is true."
    }
    prevent_destroy = true  # Managed centrally via locals.tf
  }

  depends_on = [
    azurerm_subnet.bastion_subnet,
    azurerm_public_ip.bastion_pip
  ]
}

//Firewall-Based Resources

#Special subnet for Azure Firewall
resource "azurerm_subnet" "firewall_subnet" {
  for_each              = var.enable_azure_firewall ? { "main" = {} } : {}
  name                  = "AzureFirewallSubnet"
  resource_group_name   = var.rg_name
  virtual_network_name  = azurerm_virtual_network.myvnet.name
  address_prefixes      = [var.firewall_subnet_address]
  
  # Add validation and dependency management
  lifecycle {
    precondition {
      condition     = !var.enable_azure_firewall || var.firewall_subnet_address != null
      error_message = "firewall_subnet_address must be provided when enable_azure_firewall is true."
    }
    prevent_destroy = true  # Managed centrally via locals.tf
  }

  depends_on = [azurerm_virtual_network.myvnet]
}
 
# Special subnet for Azure Firewall management
resource "azurerm_subnet" "management_subnet" {
  for_each              = var.enable_azure_firewall ? { "main" = {} } : {}
  name                  = "AzureFirewallManagementSubnet"
  resource_group_name   = var.rg_name
  virtual_network_name  = azurerm_virtual_network.myvnet.name
  address_prefixes      = [var.management_subnet_address]
  
  # Add validation and dependency management
  lifecycle {
    precondition {
      condition     = !var.enable_azure_firewall || var.management_subnet_address != null
      error_message = "management_subnet_address must be provided when enable_azure_firewall is true."
    }
    prevent_destroy = true  # Managed centrally via locals.tf
  }

  depends_on = [azurerm_virtual_network.myvnet]
}
 
# Special public IP for Azure Firewall
resource "azurerm_public_ip" "firewall_pip" {
  for_each            = var.enable_azure_firewall ? { "main" = {} } : {}
  name                = "${var.firewall_name}-pip"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = var.custom_tags

  lifecycle {
    precondition {
      condition     = !var.enable_azure_firewall || (var.firewall_name != null && var.firewall_name != "")
      error_message = "firewall_name must be provided when enable_azure_firewall is true."
    }
    prevent_destroy = true  # Managed centrally via locals.tf
  }
}

# Separate public IP for management
resource "azurerm_public_ip" "firewall_management_pip" {
  for_each            = var.enable_azure_firewall ? { "main" = {} } : {}
  name                = "${var.firewall_name}-mgmt-pip"
  location            = var.rg_location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  sku                 = "Standard"
  
  tags = var.custom_tags

  lifecycle {
    precondition {
      condition     = !var.enable_azure_firewall || (var.firewall_name != null && var.firewall_name != "")
      error_message = "firewall_name must be provided when enable_azure_firewall is true."
    }
    prevent_destroy = true  # Managed centrally via locals.tf
  }
}
 
# Azure Firewall Resource
resource "azurerm_firewall" "firewall" {
  for_each              = var.enable_azure_firewall ? { "main" = {} } : {}
  name                  = var.firewall_name
  location              = var.rg_location
  resource_group_name   = var.rg_name
  sku_name              = var.firewall_sku_name
  sku_tier              = var.firewall_sku
 
  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.firewall_subnet["main"].id
    public_ip_address_id = azurerm_public_ip.firewall_pip["main"].id
  }
 
  management_ip_configuration {
    name                 = "management-ipconfig"
    subnet_id            = azurerm_subnet.management_subnet["main"].id
    public_ip_address_id = azurerm_public_ip.firewall_management_pip["main"].id
  }
  
  tags = var.custom_tags
  lifecycle {
    precondition {
      condition     = !var.enable_azure_firewall || (var.firewall_name != null && var.firewall_name != "")
      error_message = "firewall_name must be provided when enable_azure_firewall is true."
    }
    prevent_destroy = true  # Managed centrally via locals.tf
  }

  depends_on = [
    azurerm_subnet.firewall_subnet,
    azurerm_subnet.management_subnet,
    azurerm_public_ip.firewall_pip,
    azurerm_public_ip.firewall_management_pip
  ]
}


# Azure Subnet Resource
/*
This module creates subnets within a specified Azure Virtual Network.
It supports delegation, service endpoints, and route table associations.
It is designed to be flexible, allowing for multiple subnets with different configurations.
Each subnet can have its own delegation, service endpoints, and route table association.
*/
resource "azurerm_subnet" "mysubnet" {
  for_each = var.subnets

  name                 = each.key
  resource_group_name  = var.rg_name
  virtual_network_name = azurerm_virtual_network.myvnet.name
  address_prefixes     = each.value.address_prefixes
  
  # Conditional delegation block
  dynamic "delegation" {
    for_each = each.value.delegation != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name
      
      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
  
  service_endpoints = each.value.service_endpoints != null ? each.value.service_endpoints : []
  private_endpoint_network_policies = each.value.private_endpoint_network_policies != null ? each.value.private_endpoint_network_policies : "Disabled"

  # Prevent accidental deletion and ensure proper dependencies
  lifecycle {
    prevent_destroy = true  # Managed centrally via locals.tf
    create_before_destroy = false
    ignore_changes = [
      # Ignore changes to service endpoints if they're managed externally
    ]
  }

  depends_on = [azurerm_virtual_network.myvnet]
}

// Azure Route Table Resource
resource "azurerm_route_table" "network-route-table" {
  for_each = var.route_tables

  name                          = each.key
  location                      = var.rg_location
  resource_group_name           = var.rg_name
  bgp_route_propagation_enabled = !each.value.disable_bgp_route_propagation

  dynamic "route" {
    for_each = each.value.routes
    content {
      name                   = route.value.name
      address_prefix         = route.value.address_prefix
      next_hop_type          = route.value.next_hop_type
      next_hop_in_ip_address = route.value.next_hop_in_ip_address
    }
  }

  tags = var.custom_tags
  lifecycle {
    prevent_destroy = true  # Managed centrally via locals.tf
    create_before_destroy = false
  }
}  

# Simple subnet-route table associations based on subnet's route_table field
resource "azurerm_subnet_route_table_association" "route_table_associations" {
  for_each = {
    for subnet_name, subnet_config in var.subnets : subnet_name => subnet_config
    if subnet_config.route_table != null && contains(keys(var.route_tables), subnet_config.route_table)
  }

  subnet_id      = azurerm_subnet.mysubnet[each.key].id
  route_table_id = azurerm_route_table.network-route-table[each.value.route_table].id

  # Ensure proper dependency order
  depends_on = [
    azurerm_subnet.mysubnet,
    azurerm_route_table.network-route-table
  ]

  lifecycle {
    create_before_destroy = false
  }
}

# NSG-Subnet associations based on subnet's network_security_group field
resource "azurerm_subnet_network_security_group_association" "nsg_associations" {
  for_each = {
    for subnet_name, subnet_config in var.subnets : subnet_name => subnet_config
    if subnet_config.network_security_group != null && contains(keys(var.network_security_groups), subnet_config.network_security_group)
  }

  subnet_id                 = azurerm_subnet.mysubnet[each.key].id
  network_security_group_id = azurerm_network_security_group.network-nsg[each.value.network_security_group].id

  # Ensure proper dependency order
  depends_on = [
    azurerm_subnet.mysubnet,
    azurerm_network_security_group.network-nsg
  ]

  lifecycle {
    create_before_destroy = false
  }
}

# Azure Network Security Group Resource
resource "azurerm_network_security_group" "network-nsg" {
  for_each = var.network_security_groups

  name                = each.key
  location            = var.rg_location
  resource_group_name = var.rg_name
  
  dynamic "security_rule" {
    for_each = each.value.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
  
  tags = var.custom_tags

  lifecycle {
    prevent_destroy = true  # Managed centrally via locals.tf khal
    create_before_destroy = false
  }
}


# Azure Public IP Resource
resource "azurerm_public_ip" "my-pubip" {
  for_each = var.public_ip_name
  
  name                = each.key
  resource_group_name = var.rg_name
  location            = var.rg_location
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  ip_version          = each.value.ip_version

  tags = var.custom_tags

  lifecycle {
    prevent_destroy = true  # Managed centrally via locals.tf
    create_before_destroy = false
  }
}

# Azure Network Interface Resource
resource "azurerm_network_interface" "mynic" {
  for_each = var.network_interfaces
  
  name                         = each.key
  resource_group_name         = var.rg_name
  location                    = var.rg_location
  ip_forwarding_enabled       = each.value.enable_ip_forwarding
  accelerated_networking_enabled = each.value.enable_accelerated_networking
 
  ip_configuration {
    name                          = "${each.key}-internal"
    subnet_id = azurerm_subnet.mysubnet[each.value.subnet_name].id
    private_ip_address_allocation = each.value.private_ip_address_allocation
    private_ip_address           = each.value.private_ip_address_allocation == "Static" ? each.value.private_ip_address : null
    public_ip_address_id         = each.value.public_ip_name != null ? azurerm_public_ip.my-pubip[each.value.public_ip_name].id : null
  }
  
  tags = var.custom_tags

  lifecycle {
    prevent_destroy = true  # Managed centrally via locals.tf
    create_before_destroy = false
    ignore_changes = [
      # Ignore IP address changes for dynamic allocation
      ip_configuration[0].private_ip_address
    ]
  }

  depends_on = [
    azurerm_subnet.mysubnet,
    azurerm_public_ip.my-pubip
  ]
}

