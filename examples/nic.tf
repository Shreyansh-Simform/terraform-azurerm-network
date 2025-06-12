 module "complete_network" {
  source = ".."  # Path to the Network module
 
 # Network Interfaces
  network_interfaces = {
    # Web Server NIC
    "web-server-nic-01" = {
      subnet_name                   = "web-tier-subnet"
      private_ip_address_allocation = "Static"
      private_ip_address           = "10.0.1.10"
      enable_ip_forwarding         = false
      enable_accelerated_networking = true
    }

    # Web Server NIC 2
    "web-server-nic-02" = {
      subnet_name                   = "web-tier-subnet"
      private_ip_address_allocation = "Dynamic"
      enable_ip_forwarding         = false
      enable_accelerated_networking = true
    }

    # App Server NIC
    "app-server-nic-01" = {
      subnet_name                   = "app-tier-subnet"
      private_ip_address_allocation = "Static"
      private_ip_address           = "10.0.2.10"
      enable_ip_forwarding         = false
      enable_accelerated_networking = true
    }

    # App Server NIC 2
    "app-server-nic-02" = {
      subnet_name                   = "app-tier-subnet"
      private_ip_address_allocation = "Dynamic"
      enable_ip_forwarding         = false
      enable_accelerated_networking = true
    }

    # Database Server NIC
    "db-server-nic-01" = {
      subnet_name                   = "db-tier-subnet"
      private_ip_address_allocation = "Static"
      private_ip_address           = "10.0.3.10"
      enable_ip_forwarding         = false
      enable_accelerated_networking = false  # Database servers typically don't need accelerated networking
    }

    # Load Balancer NIC
    "lb-nic" = {
      subnet_name                   = "dmz-subnet"
      private_ip_address_allocation = "Static"
      private_ip_address           = "10.0.4.10"
      public_ip_name               = "lb-public-ip"
      enable_ip_forwarding         = true  # Load balancer needs IP forwarding
      enable_accelerated_networking = true
    }

    # Management VM NIC
    "mgmt-vm-nic" = {
      subnet_name                   = "management-subnet"
      private_ip_address_allocation = "Static"
      private_ip_address           = "10.0.5.10"
      public_ip_name               = "mgmt-vm-public-ip"
      enable_ip_forwarding         = false
      enable_accelerated_networking = false
    }

    # Application Gateway NIC
    "appgw-nic" = {
      subnet_name                   = "dmz-subnet"
      private_ip_address_allocation = "Static"
      private_ip_address           = "10.0.4.20"
      public_ip_name               = "appgw-public-ip"
      enable_ip_forwarding         = true
      enable_accelerated_networking = true
    }
  }
}