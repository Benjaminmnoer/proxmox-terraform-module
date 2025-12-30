output "ipset_trusted_clients_name" {
  description = "The name of the IP set containing trusted clients' IP addresses."
  value       = proxmox_virtual_environment_firewall_ipset.trusted_clients.name
}