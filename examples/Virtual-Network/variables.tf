#Name of Resource Group
variable "ResourceGroupName" {
  description = "Name of the resource group"
  type        = string
  default    = "myResourceGroup"
}

#Location of Resource Group
variable "ResourceGroupLocation" {
  description = "Location of the resource group"
  type        = string
  default    = "Central India"
}

# Virtual Network Name
variable "virtual_network_name" {
  description = "Name of the virtual network"
  type        = string
}
# Address Space for the Virtual Network
variable "address_space" {
  description = "Address space for the virtual network"
  type        = list(string)
}

# DNS Servers for the Virtual Network
variable "dns_servers" {
  description = "List of DNS servers for the virtual network"
  type        = list(string)
  default     = []
}

# Azure Bastion Variables
variable "bastion_name" {
  description = "Name of the Azure Bastion host"
  type        = string
}
 
variable "azure_bastion_subnet_prefix" {
  description = "Subnet prefix for the Azure Bastion host - /27 minimum required"
  type        = string
}
variable "azure_bastion_sku" {
  description = "SKU for the Azure Bastion host"
  type        = string
  default     = "Standard"
}
  
variable "azure_bastion_scale_units" {
  description = "Number of scale units for the Azure Bastion host"
  type        = number
  default     = 2
}

variable "azure_bastion_availability_zones" {
  description = "List of availability zones for the Azure Bastion host"
  type        = list(string)
  default     = []
}



# Azure Firewall Variables
variable "azure_firewall_name" {
  description = "Name of the Azure Firewall"
  type        = string
}

variable "azure_firewall_subnet_address" {
  description = "Subnet address for the Azure Firewall- Minimum /26 subnet size required"
  type        = string
}
 
variable "firewall_management_subnet_address" {
  description = "Subnet address for the Azure Firewall Management- Minimum /26 subnet size required"
  type        = string
}
variable "azure_firewall_sku" {
  description = "SKU for the Azure Firewall"
  type        = string
  default     = "Premium"
}
variable "azure_firewall_sku_name" {
  description = "SKU name for the Azure Firewall - AZFW_VNET or AZFW_Hub"
  type        = string          
  default   = "AZFW_VNet"   
  validation {
    condition     = contains(["AZFW_VNet", "AZFW_Hub"], var.azure_firewall_sku_name)
    error_message = "Invalid Azure Firewall SKU name. Must be 'AZFW_VNet' or 'AZFW_Hub'."
  }
}