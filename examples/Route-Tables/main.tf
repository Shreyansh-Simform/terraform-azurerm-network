# First, create a resource group (you can use the Resource-Group module or create manually)
resource "azurerm_resource_group" "resource_group" {
  name     = var.ResourceGroupName
  location = var.ResourceGroupLocation
}


module "complete_network" {
  source = ".."

# Comprehensive Route Tables
  route_tables = {
    # Web Tier Routes - Traffic through Firewall
    "web-tier-routes" = {
      disable_bgp_route_propagation = false
      routes = [
        {
          name                   = "Route-To-Internet-Via-Firewall"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.200.4"  
        },
        {
          name                   = "Route-To-App-Tier"
          address_prefix         = "10.0.2.0/24"
          next_hop_type          = "VnetLocal"
        }
      ]
    }

    # App Tier Routes
    "app-tier-routes" = {
      disable_bgp_route_propagation = false
      routes = [
        {
          name                   = "Route-To-Internet-Via-Firewall"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.200.4" 
        },
        {
          name                   = "Route-To-DB-Tier"
          address_prefix         = "10.0.3.0/24"
          next_hop_type          = "VnetLocal"
        }
      ]
    }

    # Database Tier Routes - No internet access
    "db-tier-routes" = {
      disable_bgp_route_propagation = true
      routes = [
        {
          name                   = "Route-To-App-Tier"
          address_prefix         = "10.0.2.0/24"
          next_hop_type          = "VnetLocal"
        },
        {
          name                   = "Block-Internet"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "None"
        }
      ]
    }

    # DMZ Routes
    "dmz-routes" = {
      disable_bgp_route_propagation = false
      routes = [
        {
          name                   = "Route-To-Web-Tier"
          address_prefix         = "10.0.1.0/24"
          next_hop_type          = "VnetLocal"
        }
      ]
    }

    # Management Routes
    "management-routes" = {
      disable_bgp_route_propagation = false
      routes = [
        {
          name                   = "Route-To-Internet-Via-Firewall"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.200.4"  
        }
      ]
    }

    # SQL MI Routes
    "sql-mi-routes" = {
      disable_bgp_route_propagation = false
      routes = [
        {
          name                   = "Route-SQL-MI-Management"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "Internet"
        }
      ]
    }
  }

}