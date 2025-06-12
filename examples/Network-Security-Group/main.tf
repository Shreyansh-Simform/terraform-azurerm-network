# First, create a resource group (you can use the Resource-Group module or create manually)
resource "azurerm_resource_group" "resource_group" {
  name     = var.ResourceGroupName
  location = var.ResourceGroupLocation
}

module "complete_network" {
  source = ".."

# Comprehensive Network Security Groups
  network_security_groups = {
    # Web Tier NSG - Internet facing
    "web-tier-nsg" = {
      security_rules = [
        {
          name                       = "Allow-HTTP-Inbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "Allow-HTTPS-Inbound"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "Allow-SSH-From-Bastion"
          priority                   = 120
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "10.0.100.0/27"  # Bastion subnet
          destination_address_prefix = "*"
        },
        {
          name                       = "Deny-All-Inbound"
          priority                   = 4000
          direction                  = "Inbound"
          access                     = "Deny"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }

    # Application Tier NSG - Only from Web Tier
    "app-tier-nsg" = {
      security_rules = [
        {
          name                       = "Allow-App-Port-From-Web"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "8080"
          source_address_prefix      = "10.0.1.0/24"  # Web tier subnet
          destination_address_prefix = "*"
        },
        {
          name                       = "Allow-SSH-From-Bastion"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "10.0.100.0/27"  # Bastion subnet
          destination_address_prefix = "*"
        },
        {
          name                       = "Allow-Management-Access"
          priority                   = 120
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "3389"
          source_address_prefix      = "10.0.5.0/24"  # Management subnet
          destination_address_prefix = "*"
        }
      ]
    }

    # Database Tier NSG - Only from App Tier
    "db-tier-nsg" = {
      security_rules = [
        {
          name                       = "Allow-SQL-From-App"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "1433"
          source_address_prefix      = "10.0.2.0/24"  # App tier subnet
          destination_address_prefix = "*"
        },
        {
          name                       = "Allow-MySQL-From-App"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "3306"
          source_address_prefix      = "10.0.2.0/24"  # App tier subnet
          destination_address_prefix = "*"
        },
        {
          name                       = "Allow-SSH-From-Bastion"
          priority                   = 120
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "10.0.100.0/27"  # Bastion subnet
          destination_address_prefix = "*"
        }
      ]
    }

    # DMZ NSG for Load Balancers
    "dmz-nsg" = {
      security_rules = [
        {
          name                       = "Allow-HTTP-Inbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "80"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "Allow-HTTPS-Inbound"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "443"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }

    # Management NSG
    "management-nsg" = {
      security_rules = [
        {
          name                       = "Allow-RDP-From-Corporate"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "3389"
          source_address_prefix      = "203.0.113.0/24"  # Replace with your corporate IP range
          destination_address_prefix = "*"
        },
        {
          name                       = "Allow-SSH-From-Corporate"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "22"
          source_address_prefix      = "203.0.113.0/24"  # Replace with your corporate IP range
          destination_address_prefix = "*"
        }
      ]
    }

    # SQL Managed Instance NSG
    "sql-mi-nsg" = {
      security_rules = [
        {
          name                       = "Allow-SQL-MI-Management"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "9000-9003"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        },
        {
          name                       = "Allow-SQL-MI-Health-Probe"
          priority                   = 110
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "1438"
          source_address_prefix      = "*"
          destination_address_prefix = "*"
        }
      ]
    }

    # App Service NSG
    "app-service-nsg" = {
      security_rules = [
        {
          name                       = "Allow-App-Service-Management"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "454-455"
          source_address_prefix      = "AppServiceManagement"
          destination_address_prefix = "*"
        }
      ]
    }

    # Private Endpoints NSG
    "private-endpoints-nsg" = {
      security_rules = [
        {
          name                       = "Allow-VNet-Inbound"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "*"
          source_port_range          = "*"
          destination_port_range     = "*"
          source_address_prefix      = "VirtualNetwork"
          destination_address_prefix = "VirtualNetwork"
        }
      ]
    }
  }

}