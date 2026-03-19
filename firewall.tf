resource "proxmox_virtual_environment_firewall_alias" "firewall_aliases" {
  for_each = var.firewall_aliases

  name    = each.key
  cidr    = each.value.cidr
  comment = each.value.comment
}

resource "proxmox_virtual_environment_firewall_ipset" "management" {
  name    = "management"
  comment = "Managed by Terraform"

  dynamic "cidr" {
    for_each = var.management_ipset
    content {
      name    = cidr.value.ip
      comment = cidr.value.comment != null ? cidr.value.comment : ""
    }
  }
}

resource "proxmox_virtual_environment_cluster_firewall" "cluster_fw_options" {
  depends_on = [proxmox_virtual_environment_firewall_ipset.management]

  enabled = var.firewall_enabled

  ebtables      = false
  input_policy  = "REJECT"
  output_policy = "ACCEPT"
  log_ratelimit {
    enabled = true
    burst   = 30
    rate    = "10/second"
  }
}
