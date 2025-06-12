
 # First, create a resource group (you can use the Resource-Group module or create manually)
resource "azurerm_resource_group" "resource_group" {
  name     = var.ResourceGroupName
  location = var.ResourceGroupLocation
}
 
 module "complete_network" {
  source = ".."


 # Comprehensive Subnets Configuration
  subnets = {
    # Web Tier Subnet with NSG and Route Table
    "web-tier-subnet" = {
      address_prefixes              = ["10.0.1.0/24"]
      service_endpoints            = ["Microsoft.Storage", "Microsoft.KeyVault", "Microsoft.Sql"]
      network_security_group       = "web-tier-nsg"
      route_table                  = "web-tier-routes"
      private_endpoint_network_policies = "Disabled"
    }

    # Application Tier Subnet
    "app-tier-subnet" = {
      address_prefixes              = ["10.0.2.0/24"]
      service_endpoints            = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.ServiceBus"]
      network_security_group       = "app-tier-nsg"
      route_table                  = "app-tier-routes"
      private_endpoint_network_policies = "Disabled"
    }

    # Database Tier Subnet
    "db-tier-subnet" = {
      address_prefixes              = ["10.0.3.0/24"]
      service_endpoints            = ["Microsoft.Storage", "Microsoft.Sql"]
      network_security_group       = "db-tier-nsg"
      route_table                  = "db-tier-routes"
      private_endpoint_network_policies = "Disabled"
    }

    # DMZ Subnet for Load Balancers
    "dmz-subnet" = {
      address_prefixes              = ["10.0.4.0/24"]
      service_endpoints            = ["Microsoft.Storage"]
      network_security_group       = "dmz-nsg"
      route_table                  = "dmz-routes"
      private_endpoint_network_policies = "Disabled"
    }

    # Management Subnet
    "management-subnet" = {
      address_prefixes              = ["10.0.5.0/24"]
      service_endpoints            = ["Microsoft.Storage", "Microsoft.KeyVault"]
      network_security_group       = "management-nsg"
      route_table                  = "management-routes"
      private_endpoint_network_policies = "Disabled"
    }

    # SQL Managed Instance Subnet with Delegation
    "sql-mi-subnet" = {
      address_prefixes = ["10.0.10.0/24"]
      delegation = {
        name = "sql-mi-delegation"
        service_delegation = {
          name = "Microsoft.Sql/managedInstances"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action",
            "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action",
            "Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action"
          ]
        }
      }
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
      network_security_group = "sql-mi-nsg"
      route_table = "sql-mi-routes"
    }

    # App Service Subnet with Delegation
    "app-service-subnet" = {
      address_prefixes = ["10.0.11.0/24"]
      delegation = {
        name = "app-service-delegation"
        service_delegation = {
          name = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql", "Microsoft.KeyVault"]
      network_security_group = "app-service-nsg"
    }

    # Private Endpoints Subnet
    "private-endpoints-subnet" = {
      address_prefixes              = ["10.0.12.0/24"]
      private_endpoint_network_policies = "Disabled"  # Required for private endpoints
      network_security_group       = "private-endpoints-nsg"
    }
  }
}