# First, create a resource group (you can use the Resource-Group module or create manually)
resource "azurerm_resource_group" "resource_group" {
  name     = var.ResourceGroupName
  location = var.ResourceGroupLocation
}

module "complete_network" {
  source = ".."

# Public IP Addresses
  public_ip_name = {
    # Load Balancer Public IP
    "lb-public-ip" = {
      allocation_method = "Static"
      sku              = "Standard"
      ip_version       = "IPv4"
    }

    # Application Gateway Public IP
    "appgw-public-ip" = {
      allocation_method = "Static"
      sku              = "Standard"
      ip_version       = "IPv4"
    }

    # Management VM Public IP
    "mgmt-vm-public-ip" = {
      allocation_method = "Static"
      sku              = "Standard"
      ip_version       = "IPv4"
    }

    # NAT Gateway Public IP
    "nat-gateway-public-ip" = {
      allocation_method = "Static"
      sku              = "Standard"
      ip_version       = "IPv4"
    }

    # VPN Gateway Public IP
    "vpn-gateway-public-ip" = {
      allocation_method = "Static"
      sku              = "Standard"
      ip_version       = "IPv4"
    }
  }

}