# Example: Create only a Virtual Network with minimal configuration
# This example shows how to create just a VNet without any optional resources.
# No need to specify bastion, firewall, or ddos variables when they're disabled.

module "network_vnet_only" {
  source = "../../"  # Path to the Network module
  
  # ONLY REQUIRED VARIABLES - Just 4 variables needed!
  rg_name              = "my-resource-group"
  rg_location          = "East US"
  virtual_network_name = "my-vnet"
  address_space        = ["10.0.0.0/16"]
  
  # ALL OTHER VARIABLES ARE OPTIONAL AND HAVE DEFAULTS:
  # enable_azure_bastion    = false  (default)
  # enable_azure_firewall   = false  (default)
  # enable_ddos_protection  = false  (default)
  # dns_servers            = []     (default - uses Azure DNS)
  # subnets                = {}     (default - no subnets)
  # route_tables           = {}     (default - no route tables)
  # network_security_groups = {}     (default - no NSGs)
  # public_ip_name         = {}     (default - no public IPs)
  # network_interfaces     = {}     (default - no NICs)
  # custom_tags            = {}     (default - no tags)
  
  # You don't need to specify ANY bastion, firewall, or ddos variables
  # when those features are disabled (which is the default)
}

# Outputs from the VNet-only deployment
output "vnet_id" {
  description = "The ID of the created Virtual Network"
  value       = module.network_vnet_only.virtual_network_id
}

output "vnet_name" {
  description = "The name of the created Virtual Network"
  value       = module.network_vnet_only.virtual_network_name
}

output "vnet_address_space" {
  description = "The address space of the created Virtual Network"
  value       = module.network_vnet_only.virtual_network_address_space
}