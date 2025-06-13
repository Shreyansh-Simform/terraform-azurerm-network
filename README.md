# Azure Network Module

A comprehensive Terraform module for creating and managing Azure networking resources including Virtual Networks, Subnets, Security Groups, Firewall, Bastion, and associated components with comprehensive tagging support.

## Features

### Core Networking
- **Virtual Network**: Create Azure Virtual Networks with customizable address spaces and DNS settings
- **Subnets**: Define multiple subnets with flexible configurations including delegations and service endpoints
- **Network Security Groups (NSGs)**: Create and manage security rules with automatic subnet associations
- **Route Tables**: Define custom routing with BGP propagation control and automatic subnet associations
- **Network Interfaces**: Create network interfaces with public/private IP configurations
- **Public IPs**: Manage public IP addresses with different SKUs and allocation methods

### Security Features
- **Azure Bastion**: Optional secure RDP/SSH access without exposing VMs to the internet
- **Azure Firewall**: Optional network-level firewall with management subnet support
- **DDoS Protection**: Optional DDoS Network Protection with support for existing or new protection plans

### Advanced Features
- **Conditional Resource Creation**: Uses `for_each` with boolean logic for optional security features
- **Subnet Delegation**: Support for Azure service delegations (e.g., SQL Managed Instance, App Service)
- **Service Endpoints**: Enable service endpoints for Azure services
- **Private Endpoint Policies**: Configure private endpoint network policies
- **IP Forwarding**: Enable IP forwarding on network interfaces
- **Accelerated Networking**: Support for accelerated networking on NICs
- **Comprehensive Tagging**: Apply custom tags to all supported resources for governance and cost management

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0.0 |
| azurerm | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | >= 3.0 |

## Resources Created

- `azurerm_virtual_network` - Virtual Network
- `azurerm_subnet` - Subnets (including special subnets for Bastion and Firewall)
- `azurerm_network_security_group` - Network Security Groups
- `azurerm_route_table` - Route Tables
- `azurerm_public_ip` - Public IP addresses
- `azurerm_network_interface` - Network Interfaces
- `azurerm_bastion_host` - Azure Bastion (conditional - created when enabled)
- `azurerm_firewall` - Azure Firewall (conditional - created when enabled)
- `azurerm_ddos_protection_plan` - DDoS Protection Plan (conditional - created when enabled)
- Association resources for NSGs and Route Tables

**Note**: All resources support custom tagging through the `custom_tags` variable.

## Resource Creation Logic

This module uses a simple `for_each` approach for conditional resource creation:

- **Security Features**: When enabled (`true`), exactly **1 instance** is created using the `"main"` key
- **When Disabled**: When disabled (`false`), **0 instances** are created (empty map)
- **Resource References**: Conditional resources use the `["main"]` key for references

Example internal logic:
```hcl
# Creates 1 Bastion instance when enabled, 0 when disabled
for_each = var.enable_azure_bastion ? { "main" = {} } : {}

# Resource reference
subnet_id = azurerm_subnet.bastion_subnet["main"].id
```

## Usage Examples

### Basic Virtual Network with Subnets

```hcl
module "network" {
  source = "./child_modules/Network"

  # Basic Configuration
  rg_name              = "my-resource-group"
  rg_location          = "East US"
  virtual_network_name = "my-vnet"
  address_space        = ["10.0.0.0/16"]
  dns_servers          = ["8.8.8.8", "8.8.4.4"]

  # Subnets Configuration
  subnets = {
    "web-subnet" = {
      address_prefixes = ["10.0.1.0/24"]
      service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
    }
    "app-subnet" = {
      address_prefixes = ["10.0.2.0/24"]
      private_endpoint_network_policies = "Enabled"
    }
    "db-subnet" = {
      address_prefixes = ["10.0.3.0/24"]
    }
  }

  # Empty configurations for optional resources
  route_tables = {}
  network_security_groups = {}
  public_ip_name = {}
  network_interfaces = {}

  # Custom Tags
  custom_tags = {
    Environment = "Development"
    Project     = "MyApp"
    Owner       = "DevTeam"
    CostCenter  = "Engineering"
  }
}
```

### Complete Network with Security Features and Tags

```hcl
module "secure_network" {
  source = "./child_modules/Network"

  # Basic Configuration
  rg_name              = "secure-rg"
  rg_location          = "East US"
  virtual_network_name = "secure-vnet"
  address_space        = ["10.0.0.0/16"]
  dns_servers          = ["168.63.129.16"]

  # Security Features
  enable_ddos_protection = true
  enable_azure_bastion   = true
  enable_azure_firewall  = true

  # Bastion Configuration
  azure_bastion_name       = "my-bastion"
  bastion_subnet_prefix    = "10.0.100.0/27"
  bastion_sku             = "Standard"
  bastion_scale_units     = 2

  # Firewall Configuration
  firewall_name               = "my-firewall"
  firewall_subnet_address     = "10.0.200.0/26"
  management_subnet_address   = "10.0.201.0/26"
  firewall_sku               = "Standard"

  # Subnets with NSG and Route Table associations
  subnets = {
    "web-subnet" = {
      address_prefixes       = ["10.0.1.0/24"]
      network_security_group = "web-nsg"
      route_table           = "web-routes"
      service_endpoints     = ["Microsoft.Storage"]
    }
    "app-subnet" = {
      address_prefixes       = ["10.0.2.0/24"]
      network_security_group = "app-nsg"
      route_table           = "app-routes"
    }
  }

  # Network Security Groups
  network_security_groups = {
    "web-nsg" = {
      security_rules = [
        {
          name                       = "AllowHTTP"
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
          name                       = "AllowHTTPS"
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
    "app-nsg" = {
      security_rules = [
        {
          name                       = "AllowAppPort"
          priority                   = 100
          direction                  = "Inbound"
          access                     = "Allow"
          protocol                   = "Tcp"
          source_port_range          = "*"
          destination_port_range     = "8080"
          source_address_prefix      = "10.0.1.0/24"
          destination_address_prefix = "*"
        }
      ]
    }
  }

  # Route Tables
  route_tables = {
    "web-routes" = {
      disable_bgp_route_propagation = false
      routes = [
        {
          name                   = "ToFirewall"
          address_prefix         = "0.0.0.0/0"
          next_hop_type          = "VirtualAppliance"
          next_hop_in_ip_address = "10.0.200.4"
        }
      ]
    }
    "app-routes" = {
      disable_bgp_route_propagation = true
      routes = []
    }
  }

  # Public IPs
  public_ip_name = {
    "web-pip" = {
      allocation_method = "Static"
      sku              = "Standard"
      ip_version       = "IPv4"
    }
  }

  # Network Interfaces
  network_interfaces = {
    "web-nic" = {
      subnet_name                   = "web-subnet"
      private_ip_address_allocation = "Dynamic"
      public_ip_name               = "web-pip"
      enable_ip_forwarding         = false
      enable_accelerated_networking = true
    }
    "app-nic" = {
      subnet_name                   = "app-subnet"
      private_ip_address_allocation = "Static"
      private_ip_address           = "10.0.2.10"
      enable_ip_forwarding         = false
      enable_accelerated_networking = false
    }
  }

  # Comprehensive Custom Tags for Production Environment
  custom_tags = {
    Environment     = "Production"
    Project         = "Enterprise-App"
    CostCenter      = "IT-Infrastructure"
    Owner          = "Network-Team"
    BusinessUnit   = "Technology"
    Compliance     = "SOC2-Required"
    BackupPolicy   = "Daily"
    MaintenanceWindow = "Sunday-2AM-4AM"
    CreatedBy      = "Terraform"
    LastModified   = "2025-06-12"
    Department     = "DevOps"
    Application    = "WebApp"
    DataClassification = "Internal"
    AutoShutdown   = "false"
  }
}
```

### Subnet with Delegation Example

```hcl
module "delegated_network" {
  source = "./child_modules/Network"

  # Basic Configuration
  rg_name              = "delegation-rg"
  rg_location          = "East US"
  virtual_network_name = "delegation-vnet"
  address_space        = ["10.0.0.0/16"]
  dns_servers          = []

  # Subnet with SQL Managed Instance delegation
  subnets = {
    "sql-mi-subnet" = {
      address_prefixes = ["10.0.1.0/24"]
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
    }
  }

  # Empty configurations for optional resources
  route_tables = {}
  network_security_groups = {}
  public_ip_name = {}
  network_interfaces = {}

  # Custom Tags for SQL MI Environment
  custom_tags = {
    Environment = "Production"
    Service     = "SQL-ManagedInstance"
    Owner       = "DBA-Team"
    CostCenter  = "Database-Operations"
  }
}
```

## Input Variables

### Required Variables

| Name | Description | Type |
|------|-------------|------|
| `rg_name` | The name of the Azure Resource Group | `string` |
| `rg_location` | The Azure region where resources will be deployed | `string` |
| `virtual_network_name` | The name of the Azure Virtual Network | `string` |
| `address_space` | The address space for the Virtual Network | `list(string)` |
| `dns_servers` | The DNS servers for the Virtual Network | `list(string)` |
| `subnets` | Map of subnet configurations | `map(object)` |
| `public_ip_name` | Map of public IP configurations | `map(object)` |
| `network_interfaces` | Map of network interface configurations | `map(object)` |

### Optional Variables

#### Tagging
| Name | Description | Type | Default |
|------|-------------|------|---------|
| `custom_tags` | Custom tags to be applied to all resources | `map(string)` | `{}` |

#### Security Features (Boolean Flags)
| Name | Description | Type | Default |
|------|-------------|------|---------|
| `enable_ddos_protection` | Enable Azure DDoS Network Protection (creates 1 instance when true, 0 when false) | `bool` | `false` |
| `ddos_protection_plan_id` | ID of existing DDoS protection plan (if using existing instead of creating new) | `string` | `null` |
| `enable_azure_bastion` | Deploy Azure Bastion (creates 1 instance when true, 0 when false) | `bool` | `false` |
| `enable_azure_firewall` | Deploy Azure Firewall (creates 1 instance when true, 0 when false) | `bool` | `false` |

#### Bastion Configuration
| Name | Description | Type | Default |
|------|-------------|------|---------|
| `azure_bastion_name` | Name of the Azure Bastion resource | `string` | `null` |
| `bastion_subnet_prefix` | Address prefix for Bastion subnet (min /27) | `string` | `null` |
| `bastion_sku` | Bastion SKU (Basic or Standard) | `string` | `"Standard"` |
| `bastion_scale_units` | Scale units for Standard SKU (2-50) | `number` | `2` |
| `bastion_availability_zones` | Availability zones for Bastion public IP | `list(string)` | `["1", "2", "3"]` |

#### Firewall Configuration
| Name | Description | Type | Default |
|------|-------------|------|---------|
| `firewall_name` | Name of the Azure Firewall resource | `string` | `null` |
| `firewall_subnet_address` | Address prefix for Firewall subnet (min /26) | `string` | `null` |
| `management_subnet_address` | Address prefix for management subnet (min /26) | `string` | `null` |
| `firewall_sku` | Firewall SKU Tier | `string` | `"Standard"` |
| `firewall_sku_name` | Firewall SKU Name | `string` | `"AZFW_VNet"` |

#### Optional Resource Maps
| Name | Description | Type | Default |
|------|-------------|------|---------|
| `route_tables` | Map of route table configurations | `map(object)` | `{}` |
| `network_security_groups` | Map of NSG configurations | `map(object)` | `{}` |

## Outputs

### Virtual Network
- `virtual_network_name` - Virtual network name
- `virtual_network_id` - Virtual network ID
- `virtual_network_address_space` - Virtual network address space

### Security Features (Conditional Outputs)
- `ddos_protection_plan_id` - DDoS protection plan ID (null if not enabled)
- `ddos_protection_enabled` - DDoS protection status (boolean)
- `bastion_host_id` - Bastion host ID (null if not enabled)
- `bastion_host_fqdn` - Bastion host FQDN (null if not enabled)
- `bastion_public_ip_address` - Bastion public IP (null if not enabled)
- `firewall_id` - Firewall ID (null if not enabled)
- `firewall_public_ip_address` - Firewall public IP (null if not enabled)

### Network Components
- `subnet_ids` - Map of subnet names to IDs
- `subnet_names` - List of subnet names
- `subnets_details` - Complete subnet information
- `route_table_ids` - Map of route table names to IDs
- `network_security_group_ids` - Map of NSG names to IDs
- `public_ip_ids` - Map of public IP names to IDs
- `network_interface_ids` - Map of NIC names to IDs
- `network_summary` - Complete network configuration summary

## Tagging Strategy

### Supported Resources
The following resources support custom tagging through the `custom_tags` variable:
- Virtual Network
- Azure Bastion Host
- Azure Firewall and associated Public IPs
- Route Tables
- Network Security Groups
- Network Interfaces
- Public IP Addresses
- DDoS Protection Plan

### Tagging Best Practices
```hcl
custom_tags = {
  # Environment Classification
  Environment = "Production"  # Development, Staging, Production
  
  # Organizational Tags
  Owner       = "TeamName"
  CostCenter  = "BU-12345"
  Project     = "ProjectName"
  
  # Operational Tags
  BackupPolicy     = "Daily"
  MaintenanceWindow = "Sunday-2AM-4AM"
  AutoShutdown     = "false"
  
  # Governance Tags
  Compliance        = "SOC2-Required"
  DataClassification = "Internal"
  
  # Automation Tags
  CreatedBy    = "Terraform"
  LastModified = "2025-06-12"
}
```

### Note on Subnets
- **Subnets**: Azure subnets don't support tags directly

## Important Notes

### Resource Creation Logic
- **Security Features**: Use simple boolean flags (`enable_*`) to control resource creation
- **Instance Count**: When enabled, exactly **1 instance** of each security feature is created
- **Resource Keys**: Conditional resources use the `"main"` key internally for consistent references
- **No Conflicts**: The `"main"` key is isolated to security features and won't conflict with user-defined resource names

### Special Subnets
- **AzureBastionSubnet**: Automatically created when `enable_azure_bastion = true` (requires /27 or larger)
- **AzureFirewallSubnet**: Automatically created when `enable_azure_firewall = true` (requires /26 or larger)
- **AzureFirewallManagementSubnet**: Management subnet for Azure Firewall (requires /26 or larger)

### Validation Rules
- Bastion name is required when `enable_azure_bastion = true`
- Firewall name is required when `enable_azure_firewall = true`
- Bastion scale units must be between 2-50 for Standard SKU
- Subnet prefixes must be provided for enabled security features

### Resource Dependencies
- NSG and Route Table associations are automatically created based on subnet configuration
- Network interfaces reference subnets and public IPs by name
- All conditional security resources are created with proper dependencies
- Custom tags are applied to all supported resources automatically

### Output Behavior
- **Enabled Features**: Outputs return actual resource values
- **Disabled Features**: Outputs return `null` for disabled security features
- **Always Available**: Core networking outputs (VNet, subnets) are always available

## Common Patterns

### Hub and Spoke Architecture
Use this module to create hub networks with centralized security services (Firewall, Bastion) and spoke networks for workloads.

### Multi-tier Applications
Configure separate subnets for web, application, and database tiers with appropriate NSG rules and route tables.

### Delegated Subnets
Create subnets with service delegations for Azure PaaS services like SQL Managed Instance, App Service, etc.

## License

This module is maintained by the DevOps team for Azure networking infrastructure.