resource "proxmox_virtual_environment_acme_dns_plugin" "cloudflare" {
  plugin = "cloudflare"
  api    = "cf"
  data = {
    CF_Token = var.cloudflare_token
  }
}

resource "proxmox_virtual_environment_firewall_ipset" "proxmox_hosts" {
  name    = "proxmox_hosts"
  comment = "Managed by Terraform"

  dynamic "cidr" {
    for_each = var.cluster_nodes
    content {
      name    = cidr.value.ip
      comment = cidr.value.comment
    }
  }
}

resource "proxmox_virtual_environment_firewall_ipset" "trusted_clients" {
  name    = "trusted_clients"
  comment = "Managed by Terraform"

  dynamic "cidr" {
    for_each = var.trusted_clients
    content {
      name    = cidr.value.ip
      comment = cidr.value.comment
    }
  }
}

resource "proxmox_virtual_environment_cluster_firewall_security_group" "management" {
  depends_on = [proxmox_virtual_environment_firewall_ipset.trusted_clients]

  name    = "management"
  comment = "Managed by Terraform"

  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "Allow 8006"
    source  = "+${proxmox_virtual_environment_firewall_ipset.trusted_clients.name}"
    dest    = "+${proxmox_virtual_environment_firewall_ipset.proxmox_hosts.name}"
    dport   = "8006"
    proto   = "tcp"
    log     = "nolog"
  }

  rule {
    type    = "in"
    action  = "ACCEPT"
    comment = "Allow SSH"
    source  = "+${proxmox_virtual_environment_firewall_ipset.trusted_clients.name}"
    dest    = "+${proxmox_virtual_environment_firewall_ipset.proxmox_hosts.name}"
    macro   = "SSH"
    log     = "info"
  }
}

resource "proxmox_virtual_environment_firewall_rules" "proxmox" {
  depends_on = [proxmox_virtual_environment_cluster_firewall_security_group.management]

  for_each = var.cluster_nodes

  node_name = each.key

  rule {
    security_group = proxmox_virtual_environment_cluster_firewall_security_group.management.name
    comment        = "From security group. Managed by Terraform"
  }
}

resource "proxmox_virtual_environment_cluster_firewall" "cluster_fw_options" {
  depends_on = [proxmox_virtual_environment_firewall_rules.proxmox]

  enabled = true

  ebtables      = false
  input_policy  = "DROP"
  output_policy = "ACCEPT"
  log_ratelimit {
    enabled = true
    burst   = 30
    rate    = "10/second"
  }
}
