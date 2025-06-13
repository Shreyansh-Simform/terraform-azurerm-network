//Resource Group Name
variable "rg_name"{
  description = "The name of the Azure Resource Group where the resources will be deployed."
  type        = string
}

//Resource Group Location
variable "rg_location" {
  description = "The Azure region where the resources will be deployed."
  type        = string
}
//Name prefix for Virtual Network(Full name is defined in locals.tf)
variable "virtual_network_name" {
  description = "The name of the Azure Virtual Network."
  type        = string
}

//Address space of the Virtual Network
variable "address_space" {
  description = "The address space for the Virtual Network."
  type        = list(string)
}

//DNS Server list of the Virtual Network
variable "dns_servers" {
  description = "The DNS servers for this Virtual Network."
  type        = list(string)
}

/*
Below are variables for Security options in Virtual Network
DDos Protection can be enabled at the Virtual Network level
Bastion and Firewall will be deployed a seperate resources
*/

#Bastion
variable "enable_azure_bastion" {
  description = "Deploy Azure Bastion?  (true/false)"
  type        = bool
  default     = false
}

variable "azure_bastion_name" {
  description = "Name of the Azure Bastion resource."
  type        = string
  default     = null
  validation {
    condition     = var.enable_azure_bastion == false || (var.enable_azure_bastion == true && var.azure_bastion_name != null && var.azure_bastion_name != "")
    error_message = "azure_bastion_name is required when enable_azure_bastion is true."
  }
}

variable "bastion_subnet_prefix" {
  description = "The address prefix for the Azure Bastion subnet (must be /27 or larger)"
  type        = string
  default     = null
}
 
variable "bastion_sku" {
  description = "Bastion SKU: Basic or Standard"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard"], var.bastion_sku)
    error_message = "Bastion SKU must be either 'Basic' or 'Standard'."
  }
}

variable "bastion_availability_zones" {
  description = "Availability zones for the Bastion public IP"
  type        = list(string)
  default     = ["1", "2", "3"]
}

variable "bastion_scale_units" {
  description = "Number of scale units for Standard SKU Bastion (2-50)"
  type        = number
  default     = 2
  validation {
    condition     = var.bastion_scale_units >= 2 && var.bastion_scale_units <= 50
    error_message = "Scale units must be between 2 and 50."
  }
}

#Firewall
variable "enable_azure_firewall" {
  description = "Deploy Azure Firewall?  (true/false)"
  type        = bool
  default     = false
}

variable "firewall_name" {
  description = "Name of the Azure Firewall resource."
  type        = string
  default     = null
  validation {
    condition     = var.enable_azure_firewall == false || (var.enable_azure_firewall == true && var.firewall_name != null && var.firewall_name != "")
    error_message = "firewall_name is required when enable_azure_firewall is true."
  }
}
 
variable "firewall_subnet_address" {
  description = "The address prefix for the Azure Firewall subnet (must be /26 or larger)"
  type        = string
  default     = null
}
 
variable "management_subnet_address" {
  description = "The address prefix for the management subnet (must be /26 or larger)"
  type        = string
  default     = null
}

variable "firewall_sku" {
  description = "Firewall SKU Tier"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.firewall_sku)
    error_message = "Firewall SKU must be 'Basic', 'Standard', or 'Premium'."
  }
}

variable "firewall_sku_name" {
  description = "Firewall SKU Name"
  type        = string
  default     = "AZFW_VNet"
  validation {
    condition     = contains(["AZFW_VNet", "AZFW_Hub"], var.firewall_sku_name)
    error_message = "Firewall SKU name must be 'AZFW_VNet' or 'AZFW_Hub'."
  }
}



#DDos Protection
variable "enable_ddos_protection" {
  description = "Enable Azure DDoS Network Protection?  (true/false)"
  type        = bool
  default     = false
}

variable "ddos_protection_plan_id" {
  description = "The ID of the DDoS protection plan (if using existing plan)"
  type        = string
  default     = null
}

//Configuration block for defining multiple subnets with different configurations
variable "subnets" {
  description = "Map of subnet configurations"
  type = map(object({
    address_prefixes = list(string)
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
    service_endpoints = optional(list(string))
    // Variables for route table and MSG association
    route_table = optional(string) # Simple route table name reference
    network_security_group = optional(string) # NSG name reference for association
    private_endpoint_network_policies = optional(string) # Accepted values are Disabled, Network Security Group, or Route Tables
  }))
}

//Configuration block for defining multiple route tables with different configurations
variable "route_tables" {
  description = "Map of route table configurations"
  type = map(object({
    disable_bgp_route_propagation = optional(bool, false)
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), [])
  }))
  default = {}
}

//Configuration block for defining multiple network security groups with security rules
variable "network_security_groups" {
  description = "Map of network security group configurations"
  type = map(object({
    security_rules = optional(list(object({
      name                       = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = optional(string)
      destination_port_range     = optional(string)
      source_address_prefix      = optional(string)
      destination_address_prefix = optional(string)
    })), [])
  }))
  default = {}
}

//Configuration block for defining multiple public IPs
variable "public_ip_name" {
  description = "Map of public IP configurations where key is the IP name"
  type = map(object({
    allocation_method = string  # Static or Dynamic
    sku              = optional(string, "Basic")  # Basic or Standard
    ip_version     = optional(string, "IPv4")  # IPv4 or IPv6
  }))
 
}

//Configuration block for defining multiple network interfaces
variable "network_interfaces" {
  description = "Map of network interface configurations"
  type = map(object({
    subnet_name                   = string        # Reference to subnet name
    private_ip_address_allocation = string           # Static or Dynamic
    private_ip_address           = optional(string)  # Required if allocation is Static
    public_ip_name               = optional(string)  # Reference to public IP name (optional)
    enable_ip_forwarding         = optional(bool, false)
    enable_accelerated_networking = optional(bool, false)
  }))

}

variable "custom_tags" {
  description = "Custom tags to be applied to the resources. Only used if enable_tags is true."
  type        = map(string)
  default     = {}
}