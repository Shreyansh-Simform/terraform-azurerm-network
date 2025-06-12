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
