  # Custom Tags
module "complete_network" {
  source = ".."

  custom_tags = {
    Environment     = "Production"
    Project         = "Enterprise-Network"
    CostCenter      = "IT-Infrastructure"
    Owner          = "Network-Team"
    BusinessUnit   = "Technology"
    Compliance     = "SOC2-Required"
    BackupPolicy   = "Daily"
    MaintenanceWindow = "Sunday-2AM-4AM"
    CreatedBy      = "Terraform"
    LastModified   = "2025-06-12"
  }
}



# Output important information
output "network_summary" {
  description = "Summary of the complete network deployment"
  value = {
    virtual_network_id = module.complete_network.virtual_network_id
    virtual_network_name = module.complete_network.virtual_network_name
    
    security_features = {
      ddos_protection_enabled = module.complete_network.ddos_protection_enabled
      bastion_enabled = module.complete_network.bastion_host_id != null
      firewall_enabled = module.complete_network.firewall_id != null
    }
    
    bastion_info = {
      bastion_fqdn = module.complete_network.bastion_host_fqdn
      bastion_public_ip = module.complete_network.bastion_public_ip_address
    }
    
    firewall_info = {
      firewall_public_ip = module.complete_network.firewall_public_ip_address
      firewall_management_ip = module.complete_network.firewall_management_ip_address
    }
    
    subnet_instances = length(module.complete_network.subnet_names)
    nsg_instances = length(module.complete_network.network_security_group_names)
    route_table_instances = length(module.complete_network.route_table_names)
    public_ip_instances = length(module.complete_network.public_ip_ids)
    nic_instances = length(module.complete_network.network_interface_ids)
  }
}
