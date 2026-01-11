#################### General ####################
variable "cloudflare_token" {
  description = "Cloudflare API token with write access to DNS"
  type        = string
}

# variable "cluster_nodes" {
#   description = "List of cluster nodes"
#   type = map(object({
#     ip      = string
#   }))
# }

variable "firewall_aliases" {
  description = "Map of Proxmox firewall aliases"
  type = map(object({
    cidr = string
    comment = optional(string, "")
  }))
  default = {}
}

variable "management_ipset" {
  description = "List of allowed IPs for management access"
  type = map(object({
    ip      = string
    comment = optional(string, "")
  }))
}

variable "firewall_enabled" {
  description = "Enable or disable the DC firewall"
  type        = bool
  default     = false
}