#################### General ####################
variable "cloudflare_token" {
  description = "Cloudflare API token with write access to DNS"
  type        = string
}

variable "cluster_nodes" {
  description = "List of cluster nodes"
  type = map(object({
    ip      = string
  }))
}

variable "trusted_clients" {
  description = "List of allowed client IP for management access"
  type = map(object({
    ip      = string
    comment = string
  }))
}

variable "firewall_enabled" {
  description = "Enable or disable the firewall on the Proxmox nodes"
  type        = bool
  default     = true
}